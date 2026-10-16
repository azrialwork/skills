<!--
  06-scoring-algorithm.md -- Reference for research.

  Covers: the standalone 0-100 research-quality scoring algorithm --
  NOW-gate, six weighted categories, N/A renormalization, and a worked
  example.
-->

# Research quality scoring (0-100)

Score the deliverable, not the effort. Total is exactly 100.

## NOW-gate
> Why: A single fabricated citation or stale-as-current claim poisons the whole deliverable, no matter how polished the remaining points are.

Fail any item and the score caps at 59, whatever the points say:

- **N1 -- no fabricated citations.** Every citation URL resolves
  (`scripts/cite-check.sh` passes) and points to the source claimed.
- **N2 -- no stale-as-current.** Every claim about current state,
  versions, or dates carries a "verified as of" stamp at or after the
  date anchor. Training-data memory is never presented as current.
- **N3 -- unknowns stated.** Limitations and unanswered sub-questions
  appear explicitly; no silent gaps.

## Categories

**Source quality -- 25.** 25: key claims trace to Tier 1/2 of the
declared adapter; hierarchy declared up front and followed. 15:
mostly Tier 1/2, minor labeled reliance on weaker sources. 5: heavy
reliance on weak sources or no declared hierarchy. 0: sources missing
or untraceable.

**Currency -- 20.** 20: all currency-sensitive claims stamped
"verified as of" on/after the date anchor, re-checked live. 12: most
stamped, a few inferred from dated sources. 4: vague "currently" /
"latest" with no stamps. 0: stale data presented as current.

**Coverage -- 20.** 20: every sub-question answered or explicitly
marked unknown with a reason. 12: most answered, gaps acknowledged.
4: cherry-picked; obvious sub-questions ignored. 0: answers a
different question than asked.

**Confidence honesty -- 15.** 15: every finding graded per
`05-confidence-grading.md`; disagreements recorded; no overclaiming.
9: grades present but inconsistent, or disagreements smoothed over.
3: no grades, hedged prose instead. 0: guesses presented as facts.

**Clarity -- 10.** 10: executive summary plus scannable findings; a
busy reader gets the answer in 60 seconds. 6: complete but poorly
structured. 2: wall of text, answer buried. 0: incoherent.

**Verifiability -- 10.** 10: every factual claim has an adjacent
citation (URL + access date); a stranger could redo the research.
6: most claims cited, some citations vague. 2: sources listed but
not linked to claims. 0: no usable citations.

## N/A and renormalization
> Why: Renormalization keeps the score honest for questions where a category genuinely doesn't apply. Without it, narrow questions get punished for not being broad ones.

A category may be marked N/A with a one-line reason (e.g. Currency
N/A for a purely historical question). Remove its points from the
denominator: score = 100 x earned / applicable. Round to the nearest
integer. Bands: 90-100 Exemplary, 70-89 Mature, 60-69 Developing,
0-59 Nascent (or NOW-gate capped).

## Worked example

Question: "Is library X still maintained per 2026-10-14?" Adapter:
technical tools. Findings: repo archived 2026-08-02 (Tier 1, High);
last release 2026-07-15 (Tier 1, High); one blog claims a fork is
active (Tier 3, Low, single source). Coverage 20/20, Source 25/25,
Currency 20/20, Confidence 15/15 (fork honestly graded Low),
Clarity 8/10 (summary buries the fork note), Verifiability 10/10.
NOW-gate passes. Total: 98/100, Exemplary.
