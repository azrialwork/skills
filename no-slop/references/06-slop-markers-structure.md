<!--
  06-slop-markers-structure.md -- Reference for no-slop.

  Covers: structural patterns -- portability test, false agency,
  distant narrator, opener habits, bare-noun lists, placeholders,
  tool fingerprints. Part of the marker catalog; part B is
  02-slop-markers-structural.md.
-->

# Slop patterns -- structure, extended

## Detection algorithm
> Why: The portability test comes first because a sentence that could belong to anyone belongs to no one — filler is the root, patterns are the branches.

INPUT: the draft text.

1. Run the portability test first: for each sentence, IF it could move unchanged to another person, company, country, or product THEN flag it as filler; cut it or replace it with a fact, example, mechanism, consequence, or judgment specific to this subject. (Sentence-level form of the topic-swap liveliness test.)
2. Scan against the patterns below; IF a pattern is observed THEN record a finding with pattern name and Rule ID, and apply the THEN line.
3. Tool fingerprints (last entry) are mechanical: strip first, then flag the citation gap.

## False agency
> Why: Verbs without actors dissolve accountability — when nobody decided, nobody can be asked why.

- **Pattern:** "The decision emerged after the offsite."; "A bet lives
  or dies on distribution."; "Complaints become fixes."
- **Why it reads as AI:** inanimate things given human verbs, so nobody
  is accountable.
- **THEN:** name the actor the source identifies ("The board decided after the offsite."); NEVER invent one.
- **Rule:** Q-01.

## Narrator-from-a-distance
> Why: Floating above the scene keeps the reader outside it — distance is where specifics go to die.

- **Pattern:** "Nobody designed this."; "This happens because...";
  "People tend to...".
- **Why it reads as AI:** floating above the scene instead of putting
  the reader in it.
- **THEN:** put the reader in the scene ("You don't sit down one day and decide to...").
- **Rule:** Q-01.

## Wh- openers and lazy extremes
> Why: An opener that becomes a crutch and an extreme that borrows authority both substitute formula for thought.

- **Pattern:** sentences starting "What makes this hard is...",
  "Why this matters..."; sweeping "every", "always", "never",
  "everyone", "nobody".
- **Why it reads as AI:** the opener becomes a crutch; the extreme
  borrows false authority.
- **THEN:** lead with the subject or verb; replace extremes with specifics.
- **Rule:** Q-02, Q-05.

## Bullet lists of bare noun phrases
> Why: Perfect symmetry with no checkable claim is packaging, not information — the reader gets a brochure, not facts.

- **Pattern:** 5+ consecutive bullets, each a short adjective-noun
  phrase with no verb ("Stable mining efficiency", "Reliable pool
  connectivity").
- **Why it reads as AI:** the symmetry is the tell -- every item the
  same shape, none asserting anything checkable.
- **THEN:** convert to prose with real claims; keep the list only if bare phrases are the correct form (changelogs, parameters, todos).
- **Rule:** P-01.

## Unfilled placeholders
> Why: A placeholder in published text is a promise broken in public — the gap the author meant to fill, shipped as-is.

- **Pattern:** `[Your Name]`, `[INSERT SOURCE URL]`, `2025-XX-XX`,
  `<!-- Add citation if available -->` in publication-ready prose.
- **Why it reads as AI:** slot-fillers meant to be replaced before
  publishing.
- **THEN:** fill only with user-supplied content, or flag the gap. (Preserve placeholders in templates and drafts where intentional.)
- **Rule:** H-01.

## AI-tool fingerprints
> Why: A leaked citation token is proof of paste-without-cleanup — it tells the reader the text was never truly finished.

- **Pattern:** citation tokens leaked from chat UIs (`citeturn0search0`,
  `[oaicite:0]`, `[attached_file:1]`); AI-referrer URL params
  (`utm_source=chatgpt.com`, `utm_source=claude.ai`).
- **Why it matters:** not a style tell -- a fingerprint. Presence alone
  proves the text was pasted from a specific tool without cleanup.
- **THEN:** strip the token or parameter mechanically; flag the citation gap rather than fabricating a reference.
- **Rule:** H-04.
