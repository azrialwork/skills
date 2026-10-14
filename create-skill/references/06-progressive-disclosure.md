<!--
  references/06-progressive-disclosure.md -- The three disclosure stages and
  their token budgets: why SKILL.md must stay lean and references/ load lazily.
-->

# Progressive Disclosure

Skills are cheap because the model does not read them all up front. Disclosure
happens in three stages, and each stage has a token budget you must respect.

## The three stages

> Why: Every token spent at startup is spent by every skill at once, which is why the shared budget is the first thing to protect.

| Stage | What loads | Budget | Trigger |
|---|---|---|---|
| 1. Metadata | `name` + `description` for every discovered skill, as an `<available_skills>` block | ~100 tokens/skill; ~15 max-length skills ~= 1.5k tokens. Keep descriptions <= 1024 chars -- this is the shared budget all skills draw from. | Startup |
| 2. Instructions | Full `SKILL.md` body, as a tool result | < 5000 tokens recommended: every body line is paid on every activation | Agent calls `skill({name})` |
| 3. Resources | `scripts/`, `references/`, `assets/` | As needed: pay per file opened or executed | Skill instructions call for them -- NEVER preloaded |

## Authoring algorithm (respect the budgets)

> Why: Duplicated content is paid twice in tokens and then drifts, so the two copies eventually contradict each other.

INPUT: the draft skill content. Run every rule; ANY violation means restructure.

1. IF a section is needed only for rare edge cases THEN move it to `references/` and point at it. The body is the *working* document, not the encyclopedia.
2. IF a reference file covers more than one topic THEN split it by topic. When the agent opens a file, it pays for the whole file.
3. IF logic is repeatable and exact (parsing, validating, converting) THEN implement it in `scripts/`, NEVER as prose. Scripts execute deterministically without loading their code into context at all -- the cheapest knowledge form.
4. IF a skill is rarely needed or sensitive THEN set `metadata: {"opencode/autoinvoke": "false"}`: keeps it out of the stage-1 selection surface without unloading it. This protects the shared budget and gates risky skills.
5. NEVER duplicate content between SKILL.md and `references/`: duplication is paid twice and drifts.
