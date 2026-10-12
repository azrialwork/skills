<!--
  references/09-security.md -- Skills as a prompt-injection and supply-chain
  surface: the threat model, measured prevalence, and concrete mitigations for
  authors and installers.
-->

# Security

A skill's Markdown steers the agent's reasoning and its `scripts/` run with
the agent's full permissions (shell, filesystem, credentials, network). Treat
every skill -- especially third-party ones -- as a **prompt-injection and
supply-chain surface**, worse than a normal dependency: it executes with ambient
authority and its instructions are written to be obeyed.

## Measured prevalence

- Snyk "ToxicSkills" audit (Feb 2026, 3,984 skills scanned): **36.8% had
  security flaws, 13.4% critical, 76 confirmed malicious payloads**; 91% of
  malicious skills combined prompt injection with traditional malware.
- The Jan-Feb 2026 "ClawHavoc" campaign planted 340+ malicious skills on a
  marketplace.

Assume any skill you did not write yourself is untrusted until reviewed.

## Author mitigations

- **Least instruction.** Do not grant the agent capabilities the skill does not
  need. If a step needs network or credentials, say so explicitly and prefer
  read-only operations.
- **Harden scripts.** Validate inputs, fail closed, never `curl | bash` inside
  a skill script, pin versions of anything downloaded.
- **No exfiltration patterns.** A skill must never instruct the agent to send
  file contents, credentials, or conversation history to an external URL.
- **Mark sensitivity.** Powerful skills get `metadata:
  {"opencode/autoinvoke": "false"}` (V2) so the model does not volunteer them,
  and their body states the required `permission.skill` posture.

## Installer mitigations (document these in the skill when relevant)

- Review `SKILL.md` **and** `scripts/` before installing. Read the code; the
  prose is the social-engineering layer.
- Gate with `permission.skill` patterns: `"untrusted-*": "ask"`,
  `"experimental-*": "deny"`.
- Disable the `skill` tool entirely (`tools: { skill: false }`) for agents that
  should not load third-party skills.
- Use `OPENCODE_DISABLE_EXTERNAL_SKILLS` / `OPENCODE_DISABLE_CLAUDE_CODE_SKILLS`
  to ignore shared directories on machines where you do not control them.
- Pin skills by git ref or vendor them; the spec has no version field, so
  "latest" is a moving target.
