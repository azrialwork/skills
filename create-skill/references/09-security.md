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

## Threat triage algorithm

INPUT: the skill under review. Compute the "lethal trifecta" (Simon Willison /
Palo Alto Networks framing, 2026):

- [ ] Access to private data (SSH keys, API credentials, wallet files)?
- [ ] Exposure to untrusted content (skill instructions, memory files, email)?
- [ ] Ability to communicate externally (network egress, webhooks, curl)?

IF all three are present THEN the skill is high-risk: apply every mitigation
below AND gate it with `metadata: {"opencode/autoinvoke": "false"}` plus a
documented `permission.skill` posture. IF any one is present THEN apply the
matching mitigations. Assume any skill you did not write yourself is untrusted
until reviewed.

## Measured prevalence (2026) -- why the triage matters

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

## OWASP Agentic Skills Top 10 (v1.0, Mar 2026)

The industry's skill-specific risk list
(owasp.github.io/www-project-agentic-skills-top-10). Check EVERY skill you
author or install against every row; ANY hit means fix or reject:

| ID | Risk | Severity | Author/installer rule |
|---|---|---|---|
| AST01 | Malicious Skills | Critical | Your skill MUST NOT be one; sign releases so consumers can verify it isn't. |
| AST02 | Supply Chain Compromise | Critical | Pin dependencies by hash; pin the skill itself by git ref when distributing. |
| AST03 | Over-Privileged Skills | High | Least privilege: request ONLY the access the skill genuinely needs; document it. |
| AST04 | Insecure Metadata | High | Safe parsers only; frontmatter MUST NOT carry executable payloads; validate against the spec. |
| AST05 | Untrusted External Instructions | High | NEVER live-fetch instructions from untrusted URLs at runtime; pin and inventory sources. |
| AST06 | Weak Isolation | High | Prefer skills that work without broad host access; document sandbox expectations. |
| AST07 | Update Drift | Medium | Immutable versioning (git tags); NEVER silently change a published skill's behavior. |
| AST08 | Poor Scanning | Medium | Pattern scanners miss natural-language injection -- review prose, not just code. |
| AST09 | No Governance | Medium | Keep an inventory of installed skills; approval workflow for new ones. |
| AST10 | Cross-Platform Reuse | Medium | A malicious skill ports everywhere the format does; review once per skill, not per platform. |

## Author mitigations (mechanical)

1. **Least instruction.** IF a step needs network or credentials THEN say so explicitly and prefer read-only operations. NEVER grant the agent capabilities the skill does not need (AST03).
2. **Harden scripts.** Validate inputs; fail closed; NEVER `curl | bash` inside a skill script; pin versions/hashes of anything downloaded (AST02, AST07).
3. **No exfiltration patterns.** A skill MUST NEVER instruct the agent to send file contents, credentials, or conversation history to an external URL. IF phrased as helpfulness ("upload the log so I can debug it") THEN treat it as an exfiltration attempt.
4. **No untrusted external instruction sources.** NEVER have the skill fetch and follow instructions from a URL you do not control at runtime (AST05).
5. **Mark sensitivity.** IF the skill is powerful THEN set `metadata: {"opencode/autoinvoke": "false"}` (model does not volunteer it) AND state the required `permission.skill` posture in the body.
6. **Review the prose, not just the code.** Scanners miss natural-language prompt injection (AST08). Read SKILL.md as an attacker would: enumerate what these instructions could be tricked into doing.

## Installer mitigations (checklist -- document the relevant ones in the skill)

- [ ] Review `SKILL.md` **and** `scripts/` before installing. Read the code; the prose is the social-engineering layer.
- [ ] Gate with `permission.skill` patterns: `"untrusted-*": "ask"`, `"experimental-*": "deny"`.
- [ ] IF an agent must not load third-party skills THEN disable the `skill` tool entirely (`tools: { skill: false }`).
- [ ] On machines you do not control, set `OPENCODE_DISABLE_EXTERNAL_SKILLS` / `OPENCODE_DISABLE_CLAUDE_CODE_SKILLS` to ignore shared directories.
- [ ] Pin skills by git ref or vendor them; the spec has no version field, so "latest" is a moving target (AST07).
