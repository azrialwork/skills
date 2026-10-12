---
name: no-slop
description: Keeps AI-generated content free of AI slop. Detects and removes the lexical, structural, and substance markers of low-quality synthetic text -- cliche phrases, throat-clearing openers, formatting spam, hedging stacks, sycophancy, and verbose nothing-burgers -- through a generate-then-audit workflow with a heuristic scanner. Use when writing, reviewing, or polishing any AI-generated text (articles, docs, README, messages, reports), or when the user mentions slop, low-quality AI content, or wants human-grade output.
---

<!--
  no-slop -- SKILL.md

  Purpose: entry point for the no-slop skill. Defines the generate-then-audit
  workflow that keeps agent output free of AI slop. Marker catalogs live in
  references/; the heuristic scanner in scripts/.
-->

# no-slop

AI slop is low-quality synthetic content: fluent, confident, and empty.
This skill keeps generated text human-grade through a two-phase workflow:
write clean, then audit mechanically.

## Honest scope

No heuristic guarantees 100% slop-free output. What this skill guarantees:
every known marker class is checked, every flagged hit is fixed or
justified, and nothing ships without passing the scanner. That gets as
close to slop-free as a mechanical process can.

## Workflow

1. **Load the markers.** Read `references/01-slop-markers.md` before
   generating anything longer than a paragraph.
2. **Generate under constraints.** Follow `references/02-anti-slop-writing.md`
   while writing: concrete over generic, verified over fluent, short over
   padded.
3. **Scan.** Save the draft to a file and run
   `scripts/slop-scan.sh <file>`. It reports hits with line numbers and a
   slop score; exit nonzero means fix before shipping.
4. **Self-audit.** Walk `references/03-self-audit.md` for what the scanner
   cannot see (substance, originality, false confidence).
5. **Fix and rescan.** Rewrite flagged passages -- do not just delete the
   flagged word and keep the empty sentence. Rescan until clean.

## Reference map

| File | Covers |
|---|---|
| `references/01-slop-markers.md` | Lexical, structural, and substance markers of slop |
| `references/02-anti-slop-writing.md` | Concrete rules for clean generation |
| `references/03-self-audit.md` | Post-generation audit for what scanners miss |

Read a reference only when its phase is active.

## Scripts and assets

- `scripts/slop-scan.sh` -- heuristic scanner: checks a text file against
  the phrase list plus structural heuristics (bullet ratio, bold spam,
  emoji, hedges, sycophancy openers). Exit nonzero above threshold.
- `assets/slop-phrases.txt` -- the banned/cliche phrase list, one
  case-insensitive pattern per line. Extend it when you find new markers.

## Guardrails

- Never ship text that fails the scanner without fixing the flagged
  passages first.
- Fixing slop means rewriting the passage with real substance, not
  deleting the flagged word and keeping the hollow sentence.
- Do not "fix" slop by adding more words. Shorter is usually cleaner.
- The scanner is a floor, not a ceiling: passing it does not mean the
  text is good, only that it has no known markers. The self-audit
  decides whether it is good.
