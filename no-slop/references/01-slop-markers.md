<!--
  01-slop-markers.md -- Reference for no-slop.

  The catalog of AI slop markers with before/after examples and rule IDs.
  Each entry: the pattern, why it reads as AI, before/after, governing rule.
  Read before generating any non-trivial text.
-->

# Slop markers

## Lexical markers

### Empty AI vocabulary

- **Pattern:** verbs and abstract nouns stacked to impress without
  informing: *unlock, elevate, empower, delve, showcase, testament,
  landscape* (abstract), *journey, robust, game-changer, next-level,
  seamless, cutting-edge, revolutionary*.
- **Why it reads as AI:** these words appear far more often in
  machine-written text. They signal intent to impress, not to inform.
- **Before:** "Unlock the power of seamless collaboration to elevate
  your team's journey to the next level."
- **After:** "Work with your team in one shared space."
- **Rule:** H-01 (no fabricated claims), P-05 (metaphors need purpose).

### Significance inflation

- **Pattern:** "the future of X", "marking a pivotal moment",
  "a new era of", "revolutionizing".
- **Why it reads as AI:** the claim has no evidence behind it, and the
  sentence reads the same no matter what the subject does. Ceremony
  where content should be.
- **Before:** "Our platform is marking a pivotal moment, ushering in
  a new era of work."
- **After:** "Our platform cuts the time your team spends on status
  meetings." (Or cut it if you cannot say what it does.)
- **Rule:** H-01, Q-05.

### Weasel attributions

- **Pattern:** "Experts say", "industry observers", "people report",
  "leading analysts believe" -- with no one named.
- **Why it reads as AI:** the attribution dresses an unsourced claim in
  authority. If the authority is real, name it; if not, the claim gets
  no costume.
- **Before:** "Experts say this approach dramatically improves conversion."
- **After:** "In a 2024 study by [named firm], this approach improved
  conversion by [real figure]." (Or cut the sentence.)
- **Rule:** H-01, H-04.

### Throat-clearing openers

- **Pattern:** "Great question!", "Excellent question!", "As an AI",
  "Certainly!", "Absolutely!".
- **Why it reads as AI:** filler before the answer. A human who knows
  the subject starts with the answer.
- **Before:** "Great question! In today's fast-paced world, ..."
- **After:** [the answer, directly].
- **Rule:** H-03.

### Hollow transitions

- **Pattern:** "Furthermore", "Moreover", "Additionally",
  "In conclusion", "It's important to note", "It's worth noting".
- **Why it reads as AI:** scaffolding that adds no meaning. If the
  paragraph needs "Furthermore" to connect, the connection is weak.
- **Before:** "Furthermore, it's important to note that the system
  is robust."
- **After:** "The system retries failed writes three times."
- **Rule:** Q-01.

## Structural markers

### Bullet-list everything

- **Pattern:** a wall of bullets where two sentences would do.
- **Why it reads as AI:** bullets hide thin content behind structure.
- **Before:** five bullets restating "it is fast" five ways.
- **After:** "It runs in 400ms." (Or real parallel items as bullets.)
- **Rule:** P-01.

### Bold spam

- **Pattern:** every other phrase wrapped in `**bold**`.
- **Why it reads as AI:** when everything is emphasized, nothing is.
- **Fix:** at most one bolded phrase per paragraph -- the thing the
  reader must not miss.
- **Rule:** P-02.

### Chatbot closers and fake-candid openers

- **Pattern:** "Hope this helps!", "Let me know if you need anything
  else!", "Honestly,", "To be real with you,".
- **Why it reads as AI:** canned warmth and performed candor.
- **Fix:** end when the content ends. Cut the closer.
- **Rule:** Q-03, H-03.

### Template skeletons

- **Pattern:** identical section shapes repeated mechanically -- every
  section opens the same way, lists three bullets, closes the same way.
- **Why it reads as AI:** the shape was templated, not written.
- **Fix:** break the pattern deliberately.
- **Rule:** Q-02.

## Substance markers (what scanners cannot see)

### Fabricated specifics

- **Pattern:** precise numbers, names, or quotes with no source.
- **Why it reads as AI:** precision without provenance is the most
  dangerous slop -- it looks verified and is not.
- **Rule:** H-01. Empty is better than deceptive: no numbers at all
  beats invented numbers.

### Verbose nothing-burgers

- **Pattern:** long passages that survive deletion without loss.
- **Test:** delete the sentence. If nothing is lost, it was slop.
- **Rule:** Q-01.

### Repetition in disguise

- **Pattern:** the same point reworded across three paragraphs.
- **Fix:** say it once, in the sharpest form. Cut the other two.
- **Rule:** Q-01.

## The one-line test

Read the passage aloud. If it sounds like a press release, a LinkedIn
influencer, or a model completing a prompt -- it is slop. Rewrite it
until it sounds like a competent human who knows the subject.
