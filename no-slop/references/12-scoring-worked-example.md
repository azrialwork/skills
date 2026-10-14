<!--
  12-scoring-worked-example.md -- Reference for no-slop.

  Covers: a worked example scoring a sample text end to end through all
  five steps, with the Mode 2 findings list and the contrast against
  `slop-scan.sh`. Part C of the scoring algorithm; part A is
  10-scoring-algorithm.md.
-->
# Scoring algorithm -- worked example (part C)

A sample text scored end to end through all five steps. The algorithm spec
is part A (`10-scoring-algorithm.md`).

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

