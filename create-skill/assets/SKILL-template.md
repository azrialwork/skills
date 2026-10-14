---
name: <skill-name>
description: <What the skill does -- specific capabilities>. Use when <trigger scenarios and key terms>; not for <negative trigger>.
---

<!--
  Template for a new SKILL.md. Copy this file to <skill-name>/SKILL.md and fill
  it in. Keep the frontmatter block as the very first thing in the file
  (parsers expect `---` at byte 0); repo header comments go here, after it.

  Rules: folder name == frontmatter `name` (^[a-z0-9]+(-[a-z0-9]+)*$),
  description is 1-1024 chars, third person, trigger-rich (see
  create-skill/references/05-description-guide.md). Body under ~500 lines;
  detail goes to references/. Every rule must be mechanical: numbered steps
  with explicit INPUT, IF/THEN/ELSE branches, PASS/FAIL verdicts. Ban weasel
  verbs (consider, prefer, usually, avoid). Validate with:
    python3 <repo>/create-skill/scripts/validate.py <skill-name>/
-->

# <Title>

<One paragraph: what this skill does. A filter, not a style guide -- state the job, not the taste.>

## Trigger

USE WHEN:
- <The user asks for X, or mentions <keywords>.>

DO NOT USE WHEN:
- <Easily confused task Y -- name the skill that owns Y instead.>

## Algorithm

INPUT: <what the agent needs to start: the task, the target, the existing text>

1. **<Step>.** IF <condition> THEN <action>. ELSE <action>. (See `references/<file>.md`.)
2. **<Step>.** <What to do, with the decision rule inline.>

## Verify

- [ ] PASS: <a testable condition -- a command to run, a string to check, a state to confirm>
- [ ] PASS: <another testable condition>

## Guardrails

- NEVER <absolute prohibition -- no exceptions, no softening>
- NEVER <another absolute prohibition>

## Reference map

| File | Covers |
|---|---|
| `references/<topic>.md` | <when the agent should read it> |

Read a reference only when its phase is active.

## Scripts and assets

- `scripts/<name>` -- <what it does>. Usage: `<command>`.
- `assets/<name>` -- <what it is, and when to use it>.
