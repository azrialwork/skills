<!--
  04-research-protocol.md -- Reference for research.

  Covers: the collection, currency-verification, and triangulation
  phases -- concrete rules for gathering and checking evidence.
-->

# Research protocol

## Collect (top-down)

- Work the hierarchy from Tier 1 down. Stop descending when the
  question is answered; note where you stopped.
- Log every source with URL and access date from the first touch.
  A source without a logged date is an unverified source.
- Weak sources are allowed only when labeled weak in the deliverable
  ("single forum anecdote", "undated blog post").
- Prefer the primary document over a summary of it. If you found it
  via a secondary source, still cite the primary.

## Verify currency

- Every claim about versions, release dates, prices, legal status, or
  anything worded "current" / "latest" / "now" gets a "verified as of
  <date>" stamp, checked against a live source on or after the date
  anchor.
- A dated source (e.g. "v3.2 released 2026-03-01") supports a claim
  *about that date*, not a claim about today.
- If a claim cannot be re-verified (source gone, paywalled, no
  primary exists), downgrade its confidence instead of dropping it
  silently -- see `05-confidence-grading.md`.

## Triangulate

- Important or contested claims need 2+ *independent* sources.
  Independent means: not the same document quoted twice, not a vendor
  quoting its own marketing, not two pages scraping the same feed.
- When sources disagree, record the disagreement in the deliverable
  with both sides cited. Do not average them away or pick the one
  you like without saying why.
- Trivial or purely descriptive claims (definitions, arithmetic) do
  not need triangulation -- note the exemption briefly.
