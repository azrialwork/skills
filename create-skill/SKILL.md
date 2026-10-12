---
name: create-skill
description: Guides the creation of professional Agent Skills (SKILL.md) for OpenCode and spec-compatible agents. Use when the user wants to create, scaffold, review, validate, or improve a skill; covers frontmatter rules, directory layout, description writing, progressive disclosure, discovery, invocation, permissions, security, and V1/V2 differences. Run scripts/validate.py to check a skill before publishing.
---

<!--
  create-skill/SKILL.md -- The create-skill skill: helps the user design, write,
  and validate professional Agent Skills (SKILL.md) for OpenCode (V1/V2) and
  spec-compatible agents. Body stays lean; depth lives in references/.

  NOTE: the YAML frontmatter above must be the very first thing in this file.
  Parsers expect `---` at byte 0, so the repo header comment lives here,
  after the frontmatter block, not before it.
-->

# Create Skill

You help the user design, write, and validate professional Agent Skills.

## Workflow

1. **Clarify the skill's job.** Ask what task the skill owns and when it should
   trigger. One skill = one job. See `references/01-concepts.md`.
2. **Pick the name.** Lowercase, hyphens, `^[a-z0-9]+(-[a-z0-9]+)*$`; the folder
   name must equal the frontmatter `name`. See `references/02-frontmatter.md`.
3. **Scaffold.** Create `<name>/SKILL.md` (+ `scripts/`, `references/`, `assets/`
   as needed). Start from `assets/SKILL-template.md`. See
   `references/03-anatomy.md`.
4. **Write the description.** Third person, specific capabilities + trigger
   keywords; slightly pushy -- models under-trigger. See
   `references/05-description-guide.md`.
5. **Write the body lean.** Step-by-step instructions, input/output examples,
   edge cases. Keep SKILL.md under ~500 lines; move detail to `references/`.
   See `references/03-anatomy.md` and `references/06-progressive-disclosure.md`.
6. **Bundle repeated logic as scripts.** Deterministic work goes in `scripts/`,
   not in prose. See `references/03-anatomy.md`.
7. **Set invocation behavior.** Decide model auto-invoke vs user-only `/name`.
   V1 exposes every skill as `/name` automatically; V2 uses
   `metadata: {"opencode/slash": "true"}`. See
   `references/07-invocation-permissions.md`.
8. **Review security.** Treat the skill as a prompt-injection surface; review
   `scripts/` and risky instructions before publishing. See
   `references/09-security.md`.
9. **Validate.** Run `scripts/validate.py <skill-dir>` and fix every error,
   then work through `references/10-validation-checklist.md`.
10. **Test in OpenCode.** Point `skills.paths` at the skill, restart, confirm it
    appears and triggers correctly. See `references/04-discovery.md`.

## Version notes

- **V1** (current stable): only `name` + `description` are read from frontmatter;
  every skill is auto-exposed as `/name`; no `metadata` behavior.
- **V2** (in development): adds the `metadata` string map (`opencode/slash`,
  `opencode/autoinvoke`), `disable-model-invocation`, and name-regex enforcement.

Details live in `references/` -- consult the relevant file instead of guessing.

## Collaborating with other skills

- **no-slop:** skill prose is user-facing content. Run new SKILL.md
  text and reference docs through no-slop (DURING while writing, AFTER
  for review) so the skill reads human-grade.
- **oss-standards:** if the skill ships executable scripts or an
  installer, apply oss-standards (strict mode, no bashisms, checksums)
  to them before publishing.
