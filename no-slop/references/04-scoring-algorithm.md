<!--
  04-scoring-algorithm.md -- Reference for no-slop.

  The complete, standalone 0-100 text-quality scoring algorithm.
  Self-contained: band legend, Hard Gate binary-zero rule, capped P/Q
  deductions with density formulas and thresholds, liveliness ceiling,
  PASS threshold, pseudocode, and a worked example. Requires nothing
  outside this skill.
-->

# The no-slop scoring algorithm (0-100)

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

## Pseudocode

```
function score_text(T, S, J):            # J = human/judge inputs
    seg = segment(T)                    # W, sentences, paragraphs, lines

    # Step 1 -- Hard Gate
    if em_dash_present(T):                    return fail("H-02")
    if sycophancy_opener(seg.first_block):    return fail("H-03")
    for s in extract_specifics(T):
        if not resolves(s, S) and not J.h01_ok: return fail("H-01")
    for c in extract_citations(T):
        if not resolves(c, S) and not J.h04_ok: return fail("H-04")
    if not J.h03_ok_novel:                    return fail("H-03")

    # Step 2 -- Purpose-Gate
    score = 100
    score -= p01_deduction(seg) unless J.p01_reason_ok      # cap 8
    score -= p02_deduction(seg) unless J.p02_reason_ok      # cap 8
    score -= p03_deduction(seg) unless J.p03_reason_ok      # cap 8
    score -= p04_deduction(seg) unless J.p04_reason_ok      # cap 8
    score -= p05_deduction(seg) unless J.p05_reason_ok      # cap 8

    # Step 3 -- Quality Locks
    score -= q01_deduction(J.q01_fail_count)                # 0/2/4
    score -= q02_deduction(J.q02_level)                     # 0/2/4
    score -= q03_deduction(T)                               # 0/4
    score -= q04_deduction(T)                               # 0/4
    score -= q05_deduction(J.q05_count)                     # 0/2/4

    # Step 4 -- Liveliness ceiling
    if not (J.l1 and J.l2 and J.l3): score = min(score, 40)

    # Step 5 -- Verdict
    return clamp(score, 0, 100)
```

`scripts/slop-scan.sh` implements the mechanical subset of Steps 1-2
(phrase hits, density groups, structural heuristics, both hard fails)
plus informational burstiness; it is the floor the algorithm builds on.

## Worked example

Sample text T (98 words, 6 non-empty lines; no source ledger S, so
H-01/H-04 are human-attested):

> In today's fast-paced digital landscape, it's important to note that
> leveraging cutting-edge tools can potentially transform how teams
> work. Furthermore, these robust solutions offer several key benefits:
>
> - They are very fast and incredibly reliable
> - They seamlessly integrate with existing workflows
> - They truly empower teams to reach the next level
>
> Moreover, the platform is **very fast**, **incredibly robust**, and
> **truly seamless**. It is important to note that results could vary,
> and teams might need time to adapt.
>
> In conclusion, this revolutionary approach marks a pivotal moment for
> the future of work. It might be worth considering.

**Step 1 -- Hard Gate.** No em dash (H-02 pass). First block is "In
today's fast-paced..." -- not a sycophancy opener (H-03 pass). No
numbers, names, dates, quotes, or citations present; attested clean
(H-01, H-04 pass). Continue.

**Step 2 -- Purpose-Gate** (no valid reasons stated; all apply):

| Rule | Measurement | Deduction |
|---|---|---|
| P-01 | bullet_ratio = 3/6 = 0.50 -> band 0.3-0.5 | -4 |
| P-02 | 3 bold spans in one paragraph (> 1) | -8 |
| P-03 | hedges: potentially, could, might x2 = 4 hits; 4/98*1000 = 40 -> >= 12 | -8 |
| P-04 | intensifiers: very x2, incredibly x2, truly x2 = 6 hits; 6/98*1000 = 61 -> >= 12 | -8 |
| P-05 | AI-vocab: cutting-edge, robust x2, seamlessly, seamless, empower, revolutionary, pivotal moment, the future of, next level = 10 hits; 10/98*1000 = 102 -> >= 15 | -8 |

P-subtotal: 36. Score: 100 - 36 = 64.

**Step 3 -- Quality Locks** (judge inputs):

| Rule | Finding | Deduction |
|---|---|---|
| Q-01 | 2 paragraphs fail the deletion test | -2 |
| Q-02 | mild template repetition (intro / bullets / bold block / closer) | -2 |
| Q-03 | "In conclusion" present | -4 |
| Q-04 | no emoji / non-ASCII | 0 |
| Q-05 | 4+ vague claims without specifics ("transform how teams work", "key benefits") | -4 |

Q-subtotal: 12. Score: 64 - 12 = 52.

**Step 4 -- Liveliness.** Topic-swap test: swap the topic and the text
reads the same -- FAIL. Score = min(52, 40) = **40**.

**Step 5 -- Verdict: 40, band Berkembang, FAIL** (below 80).

Mode 2 findings list:

1. P-05: AI-vocab density 102/1000w (10 hits) -- decoration, no reason. -8
2. P-04: intensifier density 61/1000w (6 hits) -- padding. -8
3. P-03: hedge density 40/1000w (4 hits) -- evasion stacking. -8
4. P-02: 3 bold spans in one paragraph (max 1). -8
5. P-01: bullet ratio 0.50 (3 of 6 lines are bullets). -4
6. Q-03: decorative conclusion ("In conclusion"). -4
7. Q-05: 4+ claims without a number, name, date, or example. -4
8. Q-01: 2 paragraphs fail the deletion test. -2
9. Q-02: mild template repetition across sections. -2
10. L: topic-swap fails -- generic; score capped at 40.

For contrast, `slop-scan.sh` on the same text reports score 46/FAIL --
the mechanical floor agrees in direction; the algorithm adds the judged
layers (Q-01/Q-02/Q-05, liveliness) the script cannot see.

A clean, lively text -- no H violations, densities below every ramp,
no Q findings, all three liveliness tests passing -- scores exactly
**100**.

## What cannot be automated (explicit)

The algorithm is complete because every non-mechanical check is a named,
required input -- but the following genuinely need a human or an
LLM-judge; the script will never do them:

- **H-01 provenance / H-04 source verification.** Detecting that a
  number *exists* is mechanical; verifying it was *actually read* is a
  process check. Needs the source ledger S or human attestation.
- **Q-01 deletion test, Q-02 template detection, Q-05 claim
  specificity.** Semantic judgments about redundancy, shape, and
  "specific enough".
- **All Purpose-Gate reasons.** "What does this serve?" is a reasoning
  step, not a measurement. The densities are the trigger; the reason is
  the verdict.
- **Liveliness (all three tests).** Counterfactual re-reading; no regex
  can do it. Approximable by an LLM-judge prompt or by specificity
  metrics (named-entity density), but the judgment is the check.
- **Novel H-03 forms.** The opener list covers known patterns; new
  sycophancy shapes need a reader.

## Calibration and reliability notes (current as of 2026-10-13)

- Density ramps are anchored on practitioner heuristics: hedge density
  >= 6/1000w as high-signal, AI-vocab >= 15/1000w as high-signal, bullet
  ratio > 0.5 mirroring the scanner. They are defaults -- tune against
  labeled corpora and report precision/recall when you do.
- Statistical signals (perplexity, burstiness CV) are approximate,
  population-dependent, and never verdicts. Human sentence-length CV is
  often > 60, model output often < 30 -- but careful non-native writing
  clusters with model output on the same statistics. Liang et al.,
  *Patterns* 4(7):100779 (2023): seven detectors averaged 61.2% false
  positives on TOEFL essays by non-native writers (97.8% flagged by at
  least one detector) versus ~5% on native-speaker essays.
- Detector reliability, 2026: OpenAI retired its own classifier in July
  2023 for low accuracy; independent 2026 evaluations report large
  vendor-vs-independent accuracy gaps and near-zero reliability against
  lightly humanized text. Treat every external detector number as
  contested.
- **This score is a rubric for your own draft, not a detector for other
  people's writing and not proof of authorship.** Never accuse on
  statistics alone.
