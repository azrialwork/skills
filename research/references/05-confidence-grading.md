<!--
  05-confidence-grading.md -- Reference for research.

  Covers: the High/Medium/Low confidence scale, promotion and demotion
  rules, and how to handle unknowns.
-->

# Confidence grading

Grade every finding. Classification rules -- evaluate top-down, first match wins:

- **High** IF ALL hold: (a) the load-bearing source is Tier 1, (b) it was verified at the date anchor, (c) for important claims it is triangulated. You would bet the decision on it.
- **Medium** IF ANY hold: single credible source; Tier-1 source checked BEFORE the date anchor; minor unresolved disagreement. Good enough to plan with, not to bet on.
- **Low** IF ANY hold: weak or single anecdotal source; unverifiable claim; significant disagreement. Treat as a lead, not a finding.

## Promotion and demotion algorithm
> Why: Confidence only ever moves down because evidence degrades with time and doubt, never the reverse — grading upward is how guesses get laundered into findings.

1. Start at the level the WEAKEST load-bearing source supports.
2. Move DOWN (never up) one level for each of: staleness, disagreement, failed re-verification.
3. IF one authoritative source contradicts two weak sources THEN the authoritative source wins; you MUST say so explicitly. The 2-source rule is a heuristic, not a law.
4. IF `scripts/cite-check.sh` fails a finding's link THEN demote the finding one level until the citation is repaired or replaced.

## Unknowns
> Why: An unstated unknown doesn't disappear; it gets filled in later by whoever reads the deliverable, using their own imagination.

1. IF a sub-question has no usable source THEN emit the finding "Unknown -- no Tier-1/2 source covers X as of <date>". NEVER fill the gap with a plausible-sounding guess.
2. Cap the deliverable's OVERALL confidence at the level of its weakest load-bearing finding. State the cap in the limitations section.
