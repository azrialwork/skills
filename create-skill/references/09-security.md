<!--
  references/09-security.md -- Skills as a prompt-injection and supply-chain
  surface: the threat model, measured 2026 prevalence, the OWASP Agentic Skills
  Top 10, and concrete mitigations for authors and installers.
-->

# Security

A skill's Markdown steers the agent's reasoning and its `scripts/` run with
the agent's full permissions (shell, filesystem, credentials, network). Treat
every skill -- especially third-party ones -- as a **prompt-injection and
supply-chain surface**, worse than a normal dependency: it executes with ambient
authority and its instructions are written to be obeyed.

## The "lethal trifecta"

A skill is especially dangerous when it simultaneously has (Simon Willison /
Palo Alto Networks framing, 2026):

1. **Access to private data** (SSH keys, API credentials, wallet files),
2. **Exposure to untrusted content** (skill instructions, memory files, email),
3. **Ability to communicate externally** (network egress, webhooks, curl).

Most production agent deployments satisfy all three. Design and review skills
with that in mind.

## Measured prevalence (2026)

- Snyk "ToxicSkills" audit (Feb 5, 2026; 3,984 skills scanned): **36.8% had
  security flaws, 13.4% critical, 76 confirmed malicious payloads**; ~91% of
  malicious skills combined prompt injection with traditional malware.
- **ClawHavoc** campaign (Jan-Feb 2026): 341 malicious skills planted in 3 days
  on a registry; final tally 1,184 malicious skills across 12 publisher
  accounts (Antiy CERT).
- Snyk (Feb 2026): 280+ skills leaking API keys and PII through
  over-permissioned designs.
- Air Security (Jun-Jul 2026): a researcher-built malicious skill reached
  26,000+ agents while every tested scanner cleared it; 925 skills serving
  ~134K agents rested on hijackable dependencies ("SkillJacking").
- Check Point (Feb 2026): CVE-2025-59536 (CVSS 8.7) and CVE-2026-21852 in
  Claude Code -- repository-controlled config executing before any trust dialog.

Assume any skill you did not write yourself is untrusted until reviewed.

## OWASP Agentic Skills Top 10 (v1.0, Mar 2026)

The industry's skill-specific risk list
(owasp.github.io/www-project-agentic-skills-top-10). Check every skill you
author or install against it:

| ID | Risk | Severity | What it means for a skill author |
|---|---|---|---|
| AST01 | Malicious Skills | Critical | Your skill must not be one; sign releases so consumers can verify it isn't. |
| AST02 | Supply Chain Compromise | Critical | Pin dependencies by hash; pin the skill itself by git ref when distributing. |
| AST03 | Over-Privileged Skills | High | Least privilege: request only the access the skill genuinely needs; document it. |
| AST04 | Insecure Metadata | High | Safe parsers only; frontmatter must not carry executable payloads; validate against the spec. |
| AST05 | Untrusted External Instructions | High | No live-fetching of instructions from untrusted URLs at runtime; pin and inventory sources. |
| AST06 | Weak Isolation | High | Prefer skills that work without broad host access; document sandbox expectations. |
| AST07 | Update Drift | Medium | Immutable versioning (git tags); never silently change a published skill's behavior. |
| AST08 | Poor Scanning | Medium | Pattern scanners miss natural-language injection -- review prose, not just code. |
| AST09 | No Governance | Medium | Keep an inventory of installed skills; approval workflow for new ones. |
| AST10 | Cross-Platform Reuse | Medium | A malicious skill ports everywhere the format does; review once per skill, not per platform. |

## Author mitigations

- **Least instruction.** Do not grant the agent capabilities the skill does not
  need (AST03). If a step needs network or credentials, say so explicitly and
  prefer read-only operations.
- **Harden scripts.** Validate inputs, fail closed, never `curl | bash` inside
  a skill script, pin versions/hashes of anything downloaded (AST02, AST07).
- **No exfiltration patterns.** A skill must never instruct the agent to send
  file contents, credentials, or conversation history to an external URL. Watch
  for this phrased as helpfulness ("upload the log so I can debug it").
- **No untrusted external instruction sources.** Do not have the skill fetch
  and follow instructions from a URL you do not control at runtime (AST05).
- **Mark sensitivity.** Powerful skills get
  `metadata: {"opencode/autoinvoke": "false"}` so the model does not volunteer
  them, and their body states the required `permission.skill` posture.
- **Review the prose, not just the code.** Scanners miss natural-language
  prompt injection (AST08). Read SKILL.md as an attacker would: what could
  these instructions be tricked into doing?

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
  "latest" is a moving target (AST07).
