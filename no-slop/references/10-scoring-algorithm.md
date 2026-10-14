<!--
  10-scoring-algorithm.md -- Reference for no-slop.

  Covers: the complete, standalone 0-100 text-quality scoring algorithm --
  band legend, inputs, Hard Gate binary-zero rule, capped Purpose-Gate and
  Quality Lock deductions with density formulas and thresholds, liveliness
  ceiling, and verdict. Part A of the algorithm.
  Parts: pseudocode (11), worked example (12), limits (13).
  Requires nothing outside this skill.
-->
# The no-slop scoring algorithm (0-100) (part A)

The algorithm spec: bands, inputs, the five steps. Pseudocode is part B
(`11-scoring-pseudocode.md`), the worked example part C
(`12-scoring-worked-example.md`), limits and calibration part D
(`13-scoring-limits.md`).

Scores a text against the tiered rules (H/P/Q + liveliness). A perfectly
clean, lively text scores exactly 100. Any Hard Gate violation scores 0.

## Band legend

| Score | Band | Meaning |
|---|---|---|
| 0 | FAIL | A Hard Gate rule (H-01..H-04) was violated. Rewrite, do not tune. |
| 1-39 | Kritis | Heavy slop; needs a rewrite, not edits. |
| 40-59 | Berkembang | Partially clean; notable findings remain. |
| 60-79 | Matang | Disciplined; a few findings to fix. |
| 80-100 | Lulus | Meets the bar. 100 = clean and lively. |

PASS threshold: **80**. Thresholds below are defaults and may be tuned,
but the architecture (binary Hard Gate, capped P/Q deductions, liveliness
ceiling) is the scoring contract.

## Inputs

- **T**: the text under test.
- **S** (optional): source ledger -- the list of sources actually
  consulted while writing (files read, tool results, URLs opened).
- **Human/judge inputs** (booleans unless noted; see "What cannot be
  automated"): `h01_ok`, `h04_ok`, `h03_ok`,
  `p01_reason_ok` .. `p05_reason_ok`,
  `q01_fail_count` (int), `q02_level` (0/2/4), `q05_count` (int),
  `l1_topic_swap`, `l2_specific_context`, `l3_voice`.
- Segmentation: `W` = word count; sentences split on `[.!?]+`;
  paragraphs split on blank lines; `bullet_line` matches
  `^[ \t]*[-*][ \t]`.

## Step 1 -- Hard Gate (binary; any failure -> score 0, STOP)

| Rule | Check |
|---|---|
| H-01 no fabricated specifics | Extract candidates: numbers (`[0-9]+(%\|x\|ms\|s)?`), quoted strings (`"[^"]{8,}"`), named entities (`[A-Z][a-z]+ [A-Z][a-z]+`), dates. Each must resolve to an entry in S; without S, require `h01_ok`. Any unresolvable specific -> 0. |
| H-02 no em dash | `U+2014` present anywhere -> 0. Exact, no exceptions. |
| H-03 no sycophancy | First non-empty block matches (case-insensitive) `great question\|excellent question\|as an ai\|certainly!\|fantastic point\|you're right\|you are right\|absolutely` -> 0. Novel forms -> require `h03_ok`. |
| H-04 no invented sources | Citation-shaped strings (`[Name, Year]`, `http(s)://`, `doi:`, `"Title"`) must resolve to S; without S, require `h04_ok`. Any unresolvable citation -> 0. |

## Step 2 -- Purpose-Gate deductions (start at 100, cap 8 per rule)

For each P-rule, compute the mechanical density, then apply the
deduction -- UNLESS a stated, valid reason exists
(`pXX_reason_ok` = true waives that rule entirely). "It looks good"
is not a reason.

| Rule | Density formula | Ramp (points deducted) |
|---|---|---|
| P-01 bullets | `bullet_ratio = bullet_lines / non_empty_lines` | > 0.5 -> 8; 0.3-0.5 -> 4; < 0.3 -> 0 |
| P-02 bold | `spans` = `**...**` pairs; per-paragraph max | any paragraph > 1 span, or total spans > 10 -> 8; 2-10 spans -> 4; 0-1 -> 0 |
| P-03 hedges | `hedge_hits / W * 1000`; list: might, could, may, potentially, possibly (word-boundary) | >= 12 -> 8; >= 6 -> 5; >= 2 -> 2; < 2 or single hit -> 0 |
| P-04 intensifiers | `intens_hits / W * 1000`; list: very, really, truly, incredibly, extremely | same ramp as P-03 |
| P-05 metaphors / AI-vocab | `aivocab_hits / W * 1000`; list: the cliche-metaphor, hype-verb, and significance-inflation patterns in `assets/slop-phrases.txt` | >= 15 -> 8; >= 5 -> 4; < 5 -> 0 |

Maximum P-deduction: 40. Single isolated hedges/intensifiers are normal
prose -- density scoring requires 2+ hits.

## Step 3 -- Quality Lock deductions (0, 2, or 4 per rule; max 20)

| Rule | Check | 0 / 2 / 4 |
|---|---|---|
| Q-01 one idea per paragraph | `q01_fail_count` = paragraphs failing the deletion test | 0 / 1-2 / 3+ |
| Q-02 vary structure | `q02_level` = templated section shapes | none / mild / mechanical |
| Q-03 no decorative conclusion | mechanical: `in conclusion\|in summary\|hope this helps\|let me know if you need` | absent -> 0; present -> 4 |
| Q-04 no emoji | mechanical: byte outside `[ -~]` (POSIX `[^ -~]`, `LC_ALL=C`) outside fenced code blocks | absent -> 0; present -> 4 |
| Q-05 specifics or silence | `q05_count` = claims with evaluative adjectives but no number/name/date/example | 0 / 1-2 / 3+ |

## Step 4 -- Liveliness ceiling (not a deduction)

Three booleans: `l1_topic_swap` (would the text read the same with the
topic swapped?), `l2_specific_context` (names, situations, trade-offs
only this context provides?), `l3_voice` (read aloud: a competent human
who knows the subject?). If any is false:

```
score = min(score, 40)
```

Rationale: removing slop leaves a void; liveliness must be added. A
sterile-but-clean text is a failure to fix, not a pass.

## Step 5 -- Verdict

```
score = clamp(score, 0, 100)
PASS  iff score >= 80 and no Hard Gate violation
```

Report: the score, the band, and a numbered findings list in Mode 2
format -- each item cites the rule ID, the measured value, and a
one-line reason.

