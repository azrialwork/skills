---
name: <skill-name>
description: <What the skill does -- specific capabilities>. Use when <trigger scenarios and key terms>.
---

<!--
  Template for a new SKILL.md. Copy this file to <skill-name>/SKILL.md and fill
  it in. Keep the frontmatter block as the very first thing in the file
  (parsers expect `---` at byte 0); repo header comments go here, after it.

  Rules: folder name == frontmatter `name` (^[a-z0-9]+(-[a-z0-9]+)*$),
  description is 1-1024 chars, third person, trigger-rich. Body under ~500
  lines; detail goes to references/. Validate with:
    python3 <repo>/create-skill/scripts/validate.py <skill-name>/
-->

# <Title>

<One paragraph: what this skill does and when the agent should use it.>

## Workflow

1. **<Step>.** <What to do and why.>
2. **<Step>.** <What to do and why.>

## Input / output

- Input: <what the agent provides>
- Output: <what the agent produces>

Example:

```
<concrete example>
```

## Edge cases

- <Known failure mode and how to handle it.>

## References

- `references/<topic>.md` -- <when the agent should read it>
