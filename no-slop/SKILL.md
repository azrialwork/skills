---
name: no-slop
description: Keeps AI-generated content free of AI slop through a tiered rule system and a generate-then-audit workflow. Default to Mode 1 (DURING) for any task that produces prose -- drafting, summarizing, explaining, documenting, or polishing -- and use Mode 2 (AFTER) audit only when reviewing existing text; when in doubt whether a writing task needs this skill, it does. Enforces Hard Gate rules (no fabricated specifics, no em dash, no sycophancy, no invented sources), Purpose-Gate rules (bullets, bold, hedges, intensifiers, metaphors allowed only with a stated reason), and Quality Locks, plus a liveliness bar that rejects sterile-but-clean text; ships with the density-aware heuristic scanner `scripts/slop-scan.sh` and a standalone 0-100 scoring algorithm in `references/`; covers code-comment hygiene and UI/visual slop when the task touches code or interfaces -- not for detecting authorship, only for scoring your own draft.
---

# no-slop

A filter, not a style guide: it removes AI slop without prescribing a house style. Direction stays yours; the filter only rejects what should not be there. Honest scope: no heuristic guarantees 100% slop-free output. What is guaranteed: every known marker class is checked against tiered rules, every flagged hit is fixed or justified, the liveliness bar is met, and nothing ships without passing the Delivery Gate. The 0-100 score is a rubric for your own draft, not a detector for other people's writing and not proof of authorship. External AI-detector statistics are unreliable as verdicts (see `references/02-slop-markers-structural.md`): NEVER accuse on statistics alone.

## Trigger

USE WHEN:
- Writing, reviewing, or polishing AI-generated text.
- The user mentions slop or wants human-grade output.

DO NOT USE WHEN:
- Detecting authorship of other people's writing. This skill scores your own draft only.

## Algorithm
> Why: A filter applied halfway produces neither clean nor lively text — it just interrupts the work it was meant to protect.

INPUT: the task and (for Mode 2) the existing text.

### Step 1 -- Resolve the mode

- IF the task produces new text THEN Mode 1 (DURING).
- ELSE IF the task reviews or polishes existing text THEN Mode 2 (AFTER).
- ELSE (unclear) THEN ask the user and WAIT.

### Step 2 -- Load modules

Load ONLY the modules the task needs:

- IF prose work THEN load the core references: 01-06 markers, 07-08 rules, 09 Delivery Gate, 10-13 scoring.
- IF the task writes or edits code THEN also load `references/14-code-comment-hygiene.md`. It filters comments only; the scope guardrail (comments, never code) always holds.
- IF the task builds or edits an interface THEN also load `references/15-ui-color-layout.md`, `16-ui-type-motion.md`, `17-ui-app-copy.md`, and `18-ui-direction.md` (direction first). They are a filter, not a style guide; direction comes from the brief or DESIGN.md.

Both modes apply to the extension modules as well: their checklists run as supplements to the Delivery Gate, never replacements.

### Step 3a -- Mode 1 (DURING)

1. Load the markers: `references/01-slop-markers-lexical.md` through `references/06-slop-markers-structure.md`.
2. Declare the liveliness dials (ENERGY, RHYTHM, MOTION, each 1-3; default 2 when unstated). For a UI task, declare them at the start. For prose, RHYTHM maps to Q-02; ENERGY and MOTION stay UI-only. Dial definitions:
   - **ENERGY:** 1 calm and restrained, 2 balanced, 3 bold and expressive. Governs color intensity, type scale, decoration density.
   - **RHYTHM:** 1 uniform calm sections, 2 some variation, 3 visibly varied composition. Governs section-to-section change.
   - **MOTION:** 1 hover states only, 2 restrained transitions, 3 rich animation. Governs what is allowed to move.
3. Generate under the tiered rules (see rule catalog below): Hard Gate always; Purpose-Gate techniques ONLY with a stated reason.
4. Save the draft and run `scripts/slop-scan.sh <file>`. The scanner is density-aware (hedge/intensifier stacking scores by density per 1000 words), hard-fails em dashes and sycophancy openers, and reports burstiness as information only.
5. Delivery Gate: walk `references/09-self-audit.md`. All four blocks MUST pass: Hard Gate, Purpose-Gate, liveliness, Quality Locks.
6. IF the user requested a score OR a gate block is marginal THEN score via `references/10-scoring-algorithm.md`: Hard Gate failure = 0, Purpose-Gate and Quality Locks are capped deductions, liveliness failure caps at 40, PASS at 80+.
7. IF any check FAILS THEN rewrite the flagged passages with real substance and GOTO step 4. NEVER just delete the flagged word and keep the hollow sentence.

### Step 3b -- Mode 2 (AFTER)

1. Run `scripts/slop-scan.sh <file>` for the mechanical findings.
2. Walk `references/09-self-audit.md` for the rest.
3. Emit a numbered findings list: each item MUST cite the rule ID and a one-line reason.
4. WAIT for the user to pick numbers. Fix ONLY the picked numbers. Rescan.

### Rule catalog -- the tiered rules
> Why: Severity needs an order because polish can never average out a fatal flaw — one invented fact outweighs a hundred clean sentences.

- **Hard Gate (H-01..H-04):** absolute, no exceptions. No fabricated specifics (empty is better than deceptive), no em dash, no sycophancy or throat-clearing, no invented sources. Any violation is a FAIL.
- **Purpose-Gate (P-01..P-05):** the technique is allowed, but you MUST state what it serves. Bullets, bold, hedges, intensifiers, metaphors -- "it looks good" is not a reason; cut it.
- **Quality Locks (Q-01..Q-05):** consistency -- one idea per paragraph, varied structure, no decorative conclusion, no emoji, specifics or silence.

Full definitions in `references/07-anti-slop-rules.md`.

### Rule catalog -- editing principles
> Why: Editing that erases the writer's voice trades one emptiness for another — a draft that sounds like everyone is still slop, just polished.

- **Minimum effective edit.** Fix slop patterns, errors, repetition, and unclear passages. Leave strong human sentences alone. A rough draft with a real voice must still sound like the same person after editing. NEVER rewrite distinctive lines merely for consistency. NEVER smooth every paragraph to the same polish.
- **Voice sample overrides patterns.** IF the user provides a writing sample THEN match its sentence length, word choice, punctuation, and openings first; the sample overrides pattern rules (including H-02's em-dash ban -- IF the sample uses dashes THEN match its rate). ELSE IF the user picks a preset (casual, professional, technical, warm, or blunt) THEN set the target voice per the preset, independent of the audience.
- **Show its work.** Default output = final text plus a short summary. IF the user asks for the full trail THEN return the draft, a short list of remaining patterns, then the final rewrite.

### Rule catalog -- the liveliness bar
> Why: Slop removed leaves a void, and a void is not a virtue — sterile text still bills the reader for their time and delivers nothing.

Removing slop leaves a void; liveliness must be ADDED, not assumed. A sterile result is a failure. PASS/FAIL test -- the topic-swap test: IF the topic were swapped for another and the text read the same THEN the text is generic: FAIL. Rewrite until only this topic could have produced it. The Delivery Gate checks the work against the declared dials: an endless pulse animation with MOTION=1 is a FAIL, not a style choice.

## Verify
> Why: An unchecked draft teaches the next draft that empty is acceptable — slop compounds faster than it gets fixed.

- [ ] PASS: mode was resolved explicitly (DURING for new text, AFTER for review).
- [ ] PASS: only the modules the task needs were loaded.
- [ ] PASS: `scripts/slop-scan.sh <file>` exits 0 (or every nonzero finding was fixed or justified).
- [ ] PASS: Delivery Gate (`references/09-self-audit.md`): Hard Gate, Purpose-Gate, liveliness, and Quality Locks all pass.
- [ ] PASS: topic-swap test passes -- the text could only have come from this topic.
- [ ] PASS: (Mode 2) a numbered findings list cited rule IDs; only user-picked numbers were fixed; rescan ran.

## Guardrails
> Why: Guardrails are agreed before temptation — in the moment, every exception feels reasonable.

- NEVER ship text that fails the Delivery Gate.
- NEVER fix slop by deleting the flagged word and keeping the hollow sentence; rewrite the passage with real substance.
- NEVER "fix" slop by adding more words. Shorter is usually cleaner.
- NEVER treat the scanner as a ceiling: passing it means only that no known markers fired. The Delivery Gate decides whether the text is good.
- NEVER weaken a Hard Gate rule to simplify. H-rules have no exceptions.

## Reference map

| File | Covers |
|---|---|
| `references/01-slop-markers-lexical.md` | Lexical markers: empty vocabulary, significance inflation, weasel attributions, throat-clearing openers, hollow transitions |
| `references/02-slop-markers-structural.md` | Structural and substance markers, the one-line test, and empirical grounding |
| `references/03-slop-markers-staging.md` | Staged patterns: contrasts, one-line closers, deep-sounding sayings, run-ups, phantom arguments |
| `references/04-slop-markers-rhythm.md` | Rhythm by rule and inflation: triads, repeated openings, passive voice, stacked qualifiers, vague connections, -ing riders, sales language, borrowed authority, copula avoidance |
| `references/05-slop-markers-leftovers.md` | Leftovers: knowledge disclaimers, document-about-itself, heading echoes, decorative headings, wrong-reader writing, adjective inflation, scenario openers, false ranges, empty closers |
| `references/06-slop-markers-structure.md` | Extended structure: portability test, false agency, distant narrator, opener habits, bare-noun lists, placeholders, tool fingerprints |
| `references/07-anti-slop-rules.md` | Tiered rules: Hard Gate, Purpose-Gate, Quality Locks, plus before/after examples |
| `references/08-rule-to-check-mapping.md` | Rule-to-check mapping: mechanical probes and judge inputs per rule |
| `references/09-self-audit.md` | Delivery Gate: four audit blocks incl. liveliness, with scoring |
| `references/10-scoring-algorithm.md` | The standalone 0-100 scoring algorithm: bands, formulas, and the five steps |
| `references/11-scoring-pseudocode.md` | Pseudocode implementing the five scoring steps |
| `references/12-scoring-worked-example.md` | Worked example: a sample text scored end to end |
| `references/13-scoring-limits.md` | What cannot be automated; calibration and reliability notes |
| `references/14-code-comment-hygiene.md` | Code comments: remove AI-slop comments, keep the valuable ones, never touch the code |
| `references/15-ui-color-layout.md` | UI slop: color, decoration, layout, components |
| `references/16-ui-type-motion.md` | UI slop: typography, icons, motion |
| `references/17-ui-app-copy.md` | UI slop: app screens, UI copy, honesty, UI checklist |
| `references/18-ui-direction.md` | UI direction: Design Read, product truth, art direction, real imagery, browser self-check |

Read a reference only when its phase is active.

## Scripts and assets

- `scripts/slop-scan.sh` -- heuristic scanner: phrase list (shot and density-aware groups) plus structural heuristics (bullet ratio, bold spam, non-ASCII/emoji, hard fails for em dash and sycophancy openers) and informational burstiness. Exit nonzero above threshold.
- `assets/slop-phrases.txt` -- the banned/cliche phrase list, one case-insensitive pattern per line; `# @shots`, `# @density:<group>`, and `# @cluster:<group>` markers select the scoring mode. Extend it when you find new markers.
