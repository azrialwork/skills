<!--
  README.md -- Overview of the skills repository.

  Describes what this repo is (a personal collection of Agent Skills), the
  directory layout, how to wire it into OpenCode, and how to add a new skill.
-->

# skills

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/azrialwork/skills/badge)](https://scorecard.dev/viewer/?uri=github.com/azrialwork/skills)

A personal collection of [Agent Skills](https://agentskills.io/) (`SKILL.md`) for
OpenCode and other spec-compatible agents (Claude Code, Codex, Cursor, Gemini CLI).

## Installation

Point OpenCode at this repo in `opencode.json`:

```jsonc
{
  "skills": {
    "paths": ["~/workspace/azrial/code/skills"]
  }
}
```

Restart OpenCode after adding or changing skills.

## Quickstart

```sh
# Audit a repo against open-source standards
sh oss-standards/scripts/repo-audit.sh /path/to/repo

# Scan a draft for AI slop
sh no-slop/scripts/slop-scan.sh draft.md

# Validate a new skill (add --score for a 0-100 quality score)
python3 create-skill/scripts/validate.py my-skill

# Lint a commit message
git log -1 --format=%B | sh git-workflow/scripts/commit-lint.sh
```

## Usage

### Layout

```
<skill-name>/
  SKILL.md        # required: YAML frontmatter (name, description) + instructions
  scripts/        # optional: deterministic helper scripts
  references/     # optional: docs loaded on demand
  assets/         # optional: templates, images, data files
```

Rules: one folder per skill; the folder name must equal the frontmatter `name`
(lowercase, hyphens, `^[a-z0-9]+(-[a-z0-9]+)*$`).

### Adding a new skill

1. Create `<skill-name>/SKILL.md` with frontmatter:

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

## Troubleshooting

- **A skill never triggers:** check that `skills.paths` points at this repo
  and that OpenCode was restarted after the change. The description is the
  only thing the model sees when choosing — keep it specific and
  trigger-rich.
- **CI validation fails:** run the failing check locally first, e.g.
  `python3 create-skill/scripts/validate.py <skill>`,
  `sh no-slop/scripts/slop-scan.sh <file>`, or
  `sh oss-standards/scripts/repo-audit.sh .`, and fix what it reports.

## License

SPDX-License-Identifier: MIT -- see [LICENSE](LICENSE).
