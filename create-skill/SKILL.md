---
name: create-skill
description: Guides the creation of professional Agent Skills (SKILL.md) for OpenCode and spec-compatible agents. Use when the user wants to create, scaffold, review, validate, score, or improve a skill; covers frontmatter rules, directory layout, description writing, progressive disclosure, discovery, invocation, permissions, security, and implementation differences. Run scripts/validate.py to check a skill before publishing; not for one-off prompt shortcuts that will never be reused.
---

# Create Skill

You design, write, and validate professional Agent Skills per the Agent Skills open standard (agentskills.io) as implemented by OpenCode. Sources of truth, verified 2026-10-13: `agentskills.io/specification` and `opencode.ai/docs/skills`. Community mirrors are never authoritative.

## Trigger

> Why: A skill that cannot say when it does not apply will be invoked for the wrong jobs and blamed for the results.

USE WHEN:
- The user wants to create, scaffold, review, validate, score, or improve a skill.

DO NOT USE WHEN:
- The request is a one-off prompt shortcut that will never be reused.

## Algorithm

> Why: Without a fixed order of operations, every author improvises their own — and every improvisation is a new way for the skill to break silently.

INPUT: the user's task statement.

1. **Gate the task.** IF the task is a one-off prompt shortcut (never reused) THEN STOP -- this skill does not apply. ELSE continue.
2. **Clarify the job.** IF the user has not stated the skill's job and its trigger condition THEN ask for both and WAIT. Record them as one sentence each. IF the job contains "and" or covers two or more jobs THEN split: one skill = one job. (See `references/01-concepts.md`.)
3. **Pick the name.** The name MUST match `^[a-z0-9]+(-[a-z0-9]+)*$` and be 1-64 chars. IF the folder name != the frontmatter `name` THEN FAIL -- rename one of them so they are equal. (See `references/02-frontmatter.md`.)
4. **Scaffold.** Create `<name>/SKILL.md` from `assets/SKILL-template.md`. Add `scripts/`, `references/`, `assets/` subdirectories as needed. (See `references/03-anatomy.md`.)
5. **Write the description.** Third person. It MUST state specific capabilities AND trigger keywords, be 1-1024 chars, 1-3 sentences, and be slightly pushy (models under-trigger). (See `references/05-description-guide.md`.)
6. **Write the body lean.** Step-by-step instructions, input/output examples, edge cases. IF the body exceeds ~500 lines / 5000 tokens THEN move detail into `references/` until it fits. (See `references/03-anatomy.md`, `references/06-progressive-disclosure.md`.)
7. **Bundle repeated logic as scripts.** IF a step is deterministic THEN implement it in `scripts/`, never as prose. Scripts are the cheapest knowledge form: they execute without their code entering context.
8. **Set invocation behavior.** Decide model auto-invoke vs user-only. Portable form: `metadata: {"opencode/autoinvoke": "false"}` hides the skill from auto-selection (still loadable by exact name); `metadata: {"opencode/slash": "true"}` exposes it as `/name`. Quote metadata values as strings. NEVER use `disable-model-invocation`: it is in neither the spec nor OpenCode's official docs. (See `references/07-invocation-permissions.md`.)
9. **Review security.** Treat the skill as a prompt-injection and supply-chain surface: review `scripts/` and risky instructions before publishing, and check the skill against the OWASP Agentic Skills Top 10. (See `references/09-security.md`.)
10. **Validate and score.** Run `scripts/validate.py <skill-dir>`; fix EVERY error. THEN run `scripts/validate.py --score <skill-dir>`; the score MUST be >= 90. Work through `references/10-validation-checklist.md`. (Full algorithm: `references/11-quality-scoring.md`.)
11. **Test in OpenCode.** Point `skills.paths` at the skill and restart. Give the agent a trigger-matching task WITHOUT naming the skill; confirm it loads. IF the skill has objectively verifiable outputs THEN run 2-3 test prompts with and without the skill loaded and iterate on the differences. (See `references/04-discovery.md`.)

## Verify

> Why: Checks you run before publishing are the only thing standing between a broken skill and every agent that installs it.

- [ ] PASS: `---` is at byte 0 of SKILL.md.
- [ ] PASS: name matches `^[a-z0-9]+(-[a-z0-9]+)*$`, 1-64 chars, and equals the directory name.
- [ ] PASS: description is third person, 1-1024 chars, 1-3 sentences, names capabilities and trigger keywords.
- [ ] PASS: `scripts/validate.py <skill-dir>` exits 0 with zero errors.
- [ ] PASS: `scripts/validate.py --score <skill-dir>` returns >= 90.
- [ ] PASS: a trigger-matching task loads the skill without the user naming it.

## Guardrails

> Why: Guardrails exist because the most expensive mistakes are the ones that look reasonable in the moment.

- NEVER use `disable-model-invocation`.
- NEVER let SKILL.md exceed ~500 lines / 5000 tokens; move detail to `references/`.
- NEVER implement deterministic logic as prose; put it in `scripts/`.
- NEVER treat community mirrors as source of truth.
- NEVER rely on OpenCode V1 behavior (it auto-exposed every skill as `/name` and ignored `metadata`).

## Reference map

| File | Covers |
|---|---|
| `references/01-concepts.md` | The skill's job, one skill = one job |
| `references/02-frontmatter.md` | Frontmatter rules: name regex, description limits |
| `references/03-anatomy.md` | SKILL.md anatomy, scripts vs prose, body size budget |
| `references/04-discovery.md` | Discovery and trigger testing in OpenCode |
| `references/05-description-guide.md` | Writing specific, slightly pushy descriptions |
| `references/06-progressive-disclosure.md` | Keeping SKILL.md lean via references/ |
| `references/07-invocation-permissions.md` | `opencode/autoinvoke` and `opencode/slash` metadata |
| `references/08-spec-compatibility.md` | Agent Skills spec vs OpenCode: portability across clients |
| `references/09-security.md` | Prompt-injection and supply-chain review, OWASP Top 10 |
| `references/10-validation-checklist.md` | Pre-publish validation checklist |
| `references/11-quality-scoring.md` | Full 0-100 quality-scoring algorithm |

## Scripts and assets

- `scripts/validate.py` -- validates a skill directory. Usage: `scripts/validate.py <skill-dir>`; add `--score` for the 0-100 score. A publishable skill scores >= 90.
- `assets/SKILL-template.md` -- scaffold template for a new SKILL.md.
