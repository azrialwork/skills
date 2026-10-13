---
name: create-skill
description: Guides the creation of professional Agent Skills (SKILL.md) for OpenCode and spec-compatible agents. Use when the user wants to create, scaffold, review, validate, score, or improve a skill; covers frontmatter rules, directory layout, description writing, progressive disclosure, discovery, invocation, permissions, security, and implementation differences. Run scripts/validate.py to check a skill before publishing; not for one-off prompt shortcuts that will never be reused.
---

<!--
  create-skill/SKILL.md -- The create-skill skill: helps the user design, write,
  and validate professional Agent Skills (SKILL.md) per the Agent Skills open
  standard (agentskills.io) as implemented by OpenCode. Body stays lean; depth
  lives in references/.

  NOTE: the YAML frontmatter above must be the very first thing in this file.
  Parsers expect `---` at byte 0, so the repo header comment lives here,
  after the frontmatter block, not before it.
-->

# Create Skill

You help the user design, write, and validate professional Agent Skills.

## Workflow

1. **Clarify the skill's job.** Ask what task the skill owns and when it should
   trigger. One skill = one job. See `references/01-concepts.md`.
2. **Pick the name.** Lowercase, hyphens, `^[a-z0-9]+(-[a-z0-9]+)*$`, 1-64
   chars; the folder name must equal the frontmatter `name` (required by the
   Agent Skills spec and the official OpenCode docs). See
   `references/02-frontmatter.md`.
3. **Scaffold.** Create `<name>/SKILL.md` (+ `scripts/`, `references/`,
   `assets/` as needed). Start from `assets/SKILL-template.md`. See
   `references/03-anatomy.md`.
4. **Write the description.** Third person, specific capabilities + trigger
   keywords; slightly pushy -- models under-trigger. 1-1024 chars, one to
   three sentences. See `references/05-description-guide.md`.
5. **Write the body lean.** Step-by-step instructions, input/output examples,
   edge cases. Keep SKILL.md under ~500 lines / 5000 tokens; move detail to
   `references/`. See `references/03-anatomy.md` and
   `references/06-progressive-disclosure.md`.
6. **Bundle repeated logic as scripts.** Deterministic work goes in `scripts/`,
   not in prose. Scripts are the cheapest knowledge form: they execute without
   their code entering context. See `references/03-anatomy.md`.
7. **Set invocation behavior.** Decide model auto-invoke vs user-only access.
   Portable form: `metadata: {"opencode/autoinvoke": "false"}` hides a
   powerful skill from auto-selection (still loadable by exact name);
   `metadata: {"opencode/slash": "true"}` exposes it as `/name`. Quote metadata
   values as strings. Never use `disable-model-invocation`: it is in neither
   the spec nor OpenCode's official docs. See
   `references/07-invocation-permissions.md`.
8. **Review security.** Treat the skill as a prompt-injection and supply-chain
   surface: review `scripts/` and risky instructions before publishing, and
   check the skill against the OWASP Agentic Skills Top 10. See
   `references/09-security.md`.
9. **Validate and score.** Run `scripts/validate.py <skill-dir>` and fix every
   error, then work through `references/10-validation-checklist.md`. Score the
   skill with `scripts/validate.py --score <skill-dir>` (full algorithm in
   `references/11-quality-scoring.md`); a publishable skill scores 90+.
10. **Test in OpenCode.** Point `skills.paths` at the skill, restart, confirm
    it appears and triggers correctly: give the agent a trigger-matching task
    without naming the skill, then invoke it explicitly. For skills with
    objectively verifiable outputs, run 2-3 test prompts with and without the
    skill loaded and iterate on the differences. See `references/04-discovery.md`.

## Implementation notes

Verified 2026-10-13 against the Agent Skills specification
(agentskills.io/specification) and the official OpenCode skills documentation
(opencode.ai/docs/skills). Those two are the source of truth; community mirrors
are not. Both require: `name` matching `^[a-z0-9]+(-[a-z0-9]+)*$` (1-64 chars)
and equal to the directory name; `description` of 1-1024 chars. OpenCode honors
the `metadata` keys `opencode/slash` and `opencode/autoinvoke`. Older OpenCode
V1 installs auto-exposed every skill as `/name` and ignored `metadata` -- do
not rely on that behavior for new skills.

Details live in `references/` -- consult the relevant file instead of guessing.
