<!--
  references/03-anatomy.md -- Directory layout of a skill: SKILL.md body
  guidance, scripts/, references/, assets/, and relative-path rules.
-->

# Anatomy of a Skill Directory

```text
<skill-name>/               # must equal frontmatter `name`
|-- SKILL.md               # required: YAML frontmatter + Markdown body
|-- scripts/               # optional: executable helpers (Python/Bash/JS)
|-- references/            # optional: docs loaded on demand
|-- assets/                # optional: templates, images, data files
```

## SKILL.md body algorithm

> Why: The full body loads into context on every single activation, so every unnecessary line is a tax every agent pays forever.

INPUT: the draft body. The body MUST follow this skeleton, in order:
Trigger -> Algorithm -> Verify -> Guardrails -> Reference map -> Scripts and assets.

Construction rules:

1. **Imperative steps.** Write step-by-step instructions in imperative voice with explicit INPUT, IF/THEN/ELSE branches, and PASS/FAIL verdicts. Explain *why*, not just *what* -- but cap context at 2 sentences before each algorithm.
2. **Input/output examples.** IF a step's input or output is non-obvious THEN include a concrete example. Concrete beats abstract.
3. **Edge cases.** List every failure mode you already know, each with its handling rule.
4. **Non-obvious only.** Assume the agent is smart. IF the model already knows it THEN do not document it.
5. **Size budget.** IF the body exceeds ~500 lines / 5000 tokens THEN move detail into `references/` (one focused file per topic) until it fits. The full body loads into context on every activation: every line costs tokens every run.

## scripts/ algorithm

> Why: Prose describing deterministic steps is executed by interpretation; a script is executed by the machine. Only one of those is repeatable.

IF the agent would otherwise write the same ad-hoc script every session
THEN bundle it in `scripts/`. Scripts run deterministically **without loading
code into context**.

Packaging rules:

- Self-contained, or dependencies documented.
- Helpful error messages; handle edge cases; exit non-zero on failure.
- The skill body tells the agent *when* to run which script, NEVER *how* the script works.

## references/ algorithm

> Why: A reference file that loads when it is not needed is not documentation, it is context pollution.

Load rule: the agent reads a reference file ONLY when the skill's instructions
call for it -- NEVER preload all of them.

1. One focused topic per file; keep files small (smaller = less context).
2. Reference files with paths relative to the skill root, one level deep (`references/foo.md`). NEVER nest reference chains.
3. The agent resolves them against the skill's base directory (OpenCode tells it the base directory when the skill loads).

## assets/

Static resources: templates, images, lookup tables, example inputs. Referenced
by relative path from the skill root, same as `references/`.

## Hard rules

> Why: These four rules are the load-bearing walls. Violate any one and the skill does not degrade gracefully, it fails to load at all.

1. Frontmatter `---` block is byte 0 of SKILL.md. Repo header comments go *after* the frontmatter, NEVER before it.
2. `<skill-name>` directory == frontmatter `name`, exactly.
3. File references inside the skill are relative to the skill root.
4. SKILL.md <= ~500 lines; the rest goes to `references/`.
