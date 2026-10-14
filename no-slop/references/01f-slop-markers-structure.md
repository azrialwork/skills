<!--
  01f-slop-markers-structure.md -- Reference for no-slop.

  Covers: structural patterns -- portability test, false agency,
  distant narrator, opener habits, bare-noun lists, placeholders,
  tool fingerprints. Part of the marker catalog; part B is
  01b-slop-markers-structural.md.
-->

# Slop patterns -- structure, extended

## The portability test

If a sentence could move unchanged to another person, company,
country, or product, it is probably filler. Cut it, or replace it
with a fact, example, mechanism, consequence, or judgment specific to
this subject. The sentence-level form of the topic-swap liveliness
test.

## False agency

- **Pattern:** "The decision emerged after the offsite."; "A bet lives
  or dies on distribution."; "Complaints become fixes."
- **Why it reads as AI:** inanimate things given human verbs, so nobody
  is accountable. Name the actor the source identifies: "The board
  decided after the offsite." Never invent one.
- **Rule:** Q-01.

## Narrator-from-a-distance

- **Pattern:** "Nobody designed this."; "This happens because...";
  "People tend to...".
- **Why it reads as AI:** floating above the scene instead of putting
  the reader in it. "You don't sit down one day and decide to..."
  beats "Nobody designed this."
- **Rule:** Q-01.

## Wh- openers and lazy extremes

- **Pattern:** sentences starting "What makes this hard is...",
  "Why this matters..."; sweeping "every", "always", "never",
  "everyone", "nobody".
- **Why it reads as AI:** the opener becomes a crutch; the extreme
  borrows false authority. Lead with the subject or verb; replace
  extremes with specifics.
- **Rule:** Q-02, Q-05.

## Bullet lists of bare noun phrases

- **Pattern:** 5+ consecutive bullets, each a short adjective-noun
  phrase with no verb ("Stable mining efficiency", "Reliable pool
  connectivity").
- **Why it reads as AI:** the symmetry is the tell -- every item the
  same shape, none asserting anything checkable. Convert to prose with
  real claims, or keep the list if bare phrases are the correct form
  (changelogs, parameters, todos).
- **Rule:** P-01.

## Unfilled placeholders

- **Pattern:** `[Your Name]`, `[INSERT SOURCE URL]`, `2025-XX-XX`,
  `<!-- Add citation if available -->` in publication-ready prose.
- **Why it reads as AI:** slot-fillers meant to be replaced before
  publishing. Fill only with user-supplied content, or flag the gap.
  (Preserve placeholders in templates and drafts where intentional.)
- **Rule:** H-01.

## AI-tool fingerprints

- **Pattern:** citation tokens leaked from chat UIs (`citeturn0search0`,
  `[oaicite:0]`, `[attached_file:1]`); AI-referrer URL params
  (`utm_source=chatgpt.com`, `utm_source=claude.ai`).
- **Why it matters:** not a style tell -- a fingerprint. Presence alone
  proves the text was pasted from a specific tool without cleanup.
  Strip the token or parameter mechanically; flag the citation gap
  rather than fabricating a reference.
- **Rule:** H-04.
