<!--
  05-confidence-grading.md -- Reference for research.

  Covers: the High/Medium/Low confidence scale, promotion and demotion
  rules, and how to handle unknowns.
-->

# Confidence grading

Grade every finding. The scale:

- **High** -- Tier-1 source, verified at the date anchor, and (for
  important claims) triangulated. You would bet the decision on it.
- **Medium** -- credible source but single, or Tier-1 source checked
  before the date anchor, or minor unresolved disagreement. Good
  enough to plan with, not to bet on.
- **Low** -- weak or single anecdotal source, unverifiable claim, or
  significant disagreement. Treat as a lead, not a finding.

## Promotion and demotion

- A claim starts at the level its weakest load-bearing source
  supports, then moves down (never up) for staleness, disagreement,
  or failed re-verification.
- One authoritative source can outrank two weak ones -- say so
  explicitly when you judge that way; the 2-source rule is a
  heuristic, not a law.
- A failed `cite-check.sh` link demotes the finding one level until
  the citation is repaired or replaced.

## Unknowns

- A sub-question with no usable source is a finding: "Unknown --
  no Tier-1/2 source covers X as of <date>." Never fill the gap
  with a plausible-sounding guess.
- Cap the deliverable's overall confidence at the level of its
  weakest load-bearing finding, and say so in the limitations
  section.
