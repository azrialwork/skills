<!--
  references/06-progressive-disclosure.md -- The three disclosure stages and
  their token budgets: why SKILL.md must stay lean and references/ load lazily.
-->

# Progressive Disclosure

Skills are cheap because the model does not read them all up front. Disclosure
happens in three stages, and each stage has a token budget you must respect.

## The three stages

1. **Metadata (~100 tokens per skill).** At startup, only `name` + `description`
   are loaded for every discovered skill, embedded as an
   `<available_skills>` block. Token cost scales linearly: ~15 skills with
   max-length descriptions ~= 1.5k tokens. Keep descriptions tight and bounded
   (<=1024 chars) -- this is the shared budget all your skills draw from.
2. **Instructions (<5000 tokens recommended).** The full `SKILL.md` body loads
   only when the agent calls `skill({name})`, and arrives as a tool result.
   This is why the body must stay under ~500 lines: every line is paid on
   every activation.
3. **Resources (as needed).** `scripts/`, `references/`, and `assets/` are
   read or executed only when the skill's instructions call for them -- never
   preloaded.

## Consequences for authors

- The body is the *working* document, not the encyclopedia. If a section is
  only needed for rare edge cases, move it to `references/` and point at it.
- `references/` files should each cover one topic and stay small: when the agent
  opens one, it pays for the whole file.
- Scripts are the cheapest form of knowledge: they execute deterministically
  without loading their code into context at all. Prefer `scripts/` over prose
  for anything repeatable and exact (parsing, validating, converting).
- `opencode/autoinvoke: "false"` (metadata) keeps a rarely-needed or
  sensitive skill out of the model's selection surface without unloading it --
  use it to protect the stage-1 budget and to gate risky skills.
- Never duplicate content between SKILL.md and `references/`: duplication is
  paid twice and drifts.
