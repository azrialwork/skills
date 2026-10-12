---
name: no-slop
description: Keeps AI-generated content free of AI slop through a tiered rule system and a generate-then-audit workflow. Enforces Hard Gate rules (no fabricated specifics, no em dash, no sycophancy, no invented sources), Purpose-Gate rules (bullets, bold, hedges, intensifiers, metaphors allowed only with a stated reason), and Quality Locks, plus a liveliness bar that rejects sterile-but-clean text. Ships with a heuristic scanner. Use in two modes: DURING generation (filter while writing) or AFTER (audit existing text with a findings list). Use when writing, reviewing, or polishing any AI-generated text, or when the user mentions slop, low-quality AI content, or wants human-grade output.
---

<!--
  no-slop -- SKILL.md

  Purpose: entry point for the no-slop skill. Defines the two usage modes,
  the tiered rule system, and the Delivery Gate. Rule details live in
  references/; the heuristic scanner in scripts/.
-->

# no-slop

AI slop is low-quality synthetic content: fluent, confident, and empty.
This skill is a **filter, not a style guide**: it removes slop without
prescribing a house style. Direction stays yours; the filter only
rejects what should not be there.

## Honest scope

No heuristic guarantees 100% slop-free output. What this skill guarantees:
every known marker class is checked against tiered rules, every flagged
hit is fixed or justified, the liveliness bar is met, and nothing ships
without passing the Delivery Gate. That gets as close to slop-free as a
mechanical process can.

## Two usage modes

Resolve the mode before starting. Ask the user if it is not clear.

- **Mode 1 -- DURING:** apply the rules while generating. Slop never
  appears in the first place. Use when writing new text.
- **Mode 2 -- AFTER:** audit existing text. Produce a numbered findings
  list citing the violated rule (H-01, P-02, ...); the user picks which
  numbers to fix; fix them and re-run the Delivery Gate. Use when
  reviewing or polishing.

## The tiered rules

- **Hard Gate (H-01..H-04):** absolute, no exceptions. No fabricated
  specifics (empty is better than deceptive), no em dash, no sycophancy
  or throat-clearing, no invented sources. Any violation is a FAIL.
- **Purpose-Gate (P-01..P-05):** the technique is allowed, but you must
  state what it serves. Bullets, bold, hedges, intensifiers, metaphors
  -- "it looks good" is not a reason; cut it.
- **Quality Locks (Q-01..Q-05):** consistency -- one idea per paragraph,
  varied structure, no decorative conclusion, no emoji, specifics or
  silence.

Full definitions in `references/02-anti-slop-writing.md`.

## Workflow (Mode 1 -- DURING)

1. **Load the markers.** Read `references/01-slop-markers.md`.
2. **Generate under the tiered rules.** Hard Gate always; Purpose-Gate
   techniques only with a stated reason.
3. **Scan.** Save the draft and run `scripts/slop-scan.sh <file>`.
4. **Delivery Gate.** Walk `references/03-self-audit.md`: Hard Gate,
   Purpose-Gate, liveliness, Quality Locks. All four blocks must pass.
5. **Fix and rescan.** Rewrite flagged passages with real substance --
   do not just delete the flagged word and keep the hollow sentence.

## Workflow (Mode 2 -- AFTER)

1. Run `scripts/slop-scan.sh <file>` for the mechanical findings.
2. Walk `references/03-self-audit.md` for the rest.
3. Write a numbered findings list: each item cites the rule and a
   one-line reason. The user picks numbers; fix only those; rescan.

## The liveliness bar

Removing slop leaves a void; liveliness must be **added**, not assumed.
A sterile result is a failure. The text must pass the topic-swap test:
if the topic were swapped for another and the text read the same, it is
generic -- rewrite until only this topic could have produced it.

## Reference map

| File | Covers |
|---|---|
| `references/01-slop-markers.md` | Marker catalog with before/after and rule IDs |
| `references/02-anti-slop-writing.md` | Tiered rules: Hard Gate, Purpose-Gate, Quality Locks |
| `references/03-self-audit.md` | Delivery Gate: four audit blocks incl. liveliness |

Read a reference only when its phase is active.

## Scripts and assets

- `scripts/slop-scan.sh` -- heuristic scanner: phrase list plus
  structural heuristics (bullet ratio, bold spam, non-ASCII/emoji,
  em dash hard-fail, sycophancy openers). Exit nonzero above threshold.
- `assets/slop-phrases.txt` -- the banned/cliche phrase list, one
  case-insensitive pattern per line. Extend it when you find new markers.

## Collaborating with other skills

- **create-skill:** when a no-slop engagement produces a reusable
  checklist or scanner worth keeping, use create-skill to package it
  as a proper skill.
- **oss-standards:** no-slop keeps prose human-grade; oss-standards
  keeps the repo professional. When writing README.md, CHANGELOG.md,
  or docs for an oss-standards engagement, run no-slop DURING.

## Guardrails

- Never ship text that fails the Delivery Gate.
- Fixing slop means rewriting the passage with real substance, not
  deleting the flagged word and keeping the hollow sentence.
- Do not "fix" slop by adding more words. Shorter is usually cleaner.
- The scanner is a floor, not a ceiling: passing it does not mean the
  text is good, only that it has no known markers. The Delivery Gate
  decides whether it is good.
- Never weaken a Hard Gate rule to simplify. H-rules have no exceptions.
