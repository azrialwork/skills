<!--
  references/03-anatomy.md -- Directory layout of a skill: SKILL.md body
  guidance, scripts/, references/, assets/, and relative-path rules.
-->

# Anatomy of a Skill Directory

```
<skill-name>/               # must equal frontmatter `name`
|-- SKILL.md               # required: YAML frontmatter + Markdown body
|-- scripts/               # optional: executable helpers (Python/Bash/JS)
|-- references/            # optional: docs loaded on demand
|-- assets/                # optional: templates, images, data files
```

## SKILL.md body

No format is enforced, but professional skills share a shape:

- **Step-by-step instructions** in imperative voice. Explain *why*, not just
  *what* -- "explain why, don't just shout ALWAYS".
- **Input/output examples.** Concrete beats abstract.
- **Edge cases.** The failures you already know about.
- Assume the agent is smart. Document only what is non-obvious; do not narrate
  things the model already knows.

Size budget: keep SKILL.md under **~500 lines / 5000 tokens**. The full body
loads into context on activation, so every line costs tokens every time the
skill runs. Move detail into `references/` -- one focused file per topic.

## scripts/

When the agent would otherwise write the same ad-hoc script every session,
bundle it here. Scripts run deterministically **without loading code into
context**.

- Self-contained or with documented dependencies.
- Helpful error messages; handle edge cases; exit non-zero on failure.
- The skill body tells the agent *when* to run which script, not *how* the
  script works.

## references/

Additional docs the agent reads only when needed. Rules:

- One focused topic per file; keep files small (smaller = less context).
- Reference files with **paths relative to the skill root**, one level deep
  (`references/foo.md`). Avoid nested reference chains.
- The agent resolves them against the skill's base directory (OpenCode tells it
  the base directory when the skill loads).

## assets/

Static resources: templates, images, lookup tables, example inputs. Referenced
by relative path from the skill root, same as `references/`.

## Hard rules

1. Frontmatter `---` block is byte 0 of SKILL.md. Repo header comments go
   *after* the frontmatter, never before it.
2. `<skill-name>` directory == frontmatter `name`, exactly.
3. File references inside the skill are relative to the skill root.
4. SKILL.md < ~500 lines; the rest goes to `references/`.
