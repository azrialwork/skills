<!--
  04-research-protocol.md -- Reference for research.

  Covers: the collection, currency-verification, and triangulation
  phases -- concrete rules for gathering and checking evidence.
-->

# Research protocol

## Phase 1 -- Collect (top-down)
> Why: Collecting bottom-up lets the weakest sources frame the question before the authoritative ones get a word in.

1. Work the hierarchy from Tier 1 down. IF the question is answered THEN stop descending; note the tier where you stopped.
2. Log EVERY source with URL and access date from the first touch. IF a source has no logged date THEN treat it as unverified.
3. IF a source is weak THEN label it weak in the deliverable ("single forum anecdote", "undated blog post"). An unlabeled weak source MUST NOT be used.
4. IF the primary document is available THEN use it over a summary of it. IF you found it via a secondary source THEN still cite the primary.

## Phase 2 -- Verify currency
> Why: A claim without a date stamp quietly rots into a falsehood the moment the world moves on.

1. IF a claim is about versions, release dates, prices, legal status, or is worded "current" / "latest" / "now" THEN check it against a live source on or after the date anchor and stamp "verified as of <date>".
2. A dated source (e.g. "v3.2 released 2026-03-01") supports a claim ABOUT THAT DATE, not a claim about today. NEVER present it as current.
3. IF a claim cannot be re-verified (source gone, paywalled, no primary exists) THEN downgrade its confidence per `05-confidence-grading.md`. NEVER drop it silently.

## Phase 3 -- Triangulate
> Why: Averaging two disagreeing sources doesn't produce truth — it produces a third claim that nobody actually made.

1. IF a claim is important or contested THEN it requires 2+ INDEPENDENT sources. Independent means: NOT the same document quoted twice, NOT a vendor quoting its own marketing, NOT two pages scraping the same feed.
2. IF sources disagree THEN record the disagreement with both sides cited. NEVER average them away; NEVER pick a side without saying why.
3. Trivial or purely descriptive claims (definitions, arithmetic) are exempt from triangulation. Note the exemption in one line.
