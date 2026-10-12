<!--
  README.md -- Overview of the skills repository.

  Describes what this repo is (a personal collection of Agent Skills), the
  directory layout, how to wire it into OpenCode, and how to add a new skill.
-->

# skills

A personal collection of [Agent Skills](https://agentskills.io/) (`SKILL.md`) for
OpenCode and other spec-compatible agents (Claude Code, Codex, Cursor, Gemini CLI).

## Layout

```
skills/
  <skill-name>/
    SKILL.md        # required: YAML frontmatter (name, description) + instructions
    scripts/        # optional: deterministic helper scripts
    references/     # optional: docs loaded on demand
    assets/         # optional: templates, images, data files
```

Rules: one folder per skill; the folder name must equal the frontmatter `name`
(lowercase, hyphens, `^[a-z0-9]+(-[a-z0-9]+)*$`).

## Use with OpenCode

Point OpenCode at this repo's `skills/` directory in `opencode.json`:

```jsonc
{
  "skills": {
    "paths": ["~/workspace/azrial/code/skills/skills"]
  }
}
```

Restart OpenCode after adding or changing skills.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with frontmatter:

```markdown
---
name: <skill-name>
description: <what it does>. Use when <trigger scenarios and keywords>.
---

## Instructions
...
```

2. Keep `SKILL.md` under ~500 lines; move detail into `references/`.
3. Write the description in third person, specific and trigger-rich -- it is the
   only thing the model sees when choosing a skill.

## License

MIT -- see [LICENSE](LICENSE).
