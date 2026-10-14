<!--
  01-slop-markers-lexical.md -- Reference for no-slop.

  Covers: lexical AI slop markers -- empty vocabulary, significance
  inflation, weasel attributions, throat-clearing openers, hollow
  transitions -- with before/after examples and rule IDs.
  Part A of the marker catalog; part B is 02-slop-markers-structural.md.
  Read before generating any non-trivial text.
-->
# Slop markers -- lexical markers (part A)

Part A of the marker catalog: the lexical markers. Part B
(`02-slop-markers-structural.md`) covers structural and substance markers.

## Detection algorithm
> Why: Order matters because fatal flaws must fire before cosmetic ones — otherwise the hard fails get negotiated away.

INPUT: the draft text.

1. Scan the text against each marker below, in order.
2. IF a marker's Pattern is observed THEN record a finding: marker name, matched text, and Rule ID.
3. IF the Rule ID is an H-rule THEN FAIL immediately (see `07-anti-slop-rules.md`).
4. ELSE rewrite or cut the matched passage per the marker's THEN line; never keep it for emphasis.
5. Findings feed Mode 2's numbered list (`SKILL.md` Step 3b).

## Lexical markers
> Why: A vocabulary shared by millions of model outputs is a confession of authorship — readers clock it before the first paragraph ends.

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
- **THEN:** cut the word or replace it with the specific fact; IF no specific fact exists THEN cut the sentence.
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
- **THEN:** IF you can state what it does THEN replace with that; ELSE cut the sentence.
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
- **THEN:** IF the authority is real THEN name it with the figure; ELSE cut the sentence.
- **Rule:** H-01, H-04.

### Throat-clearing openers

- **Pattern:** "Great question!", "Excellent question!", "As an AI",
  "Certainly!", "Absolutely!".
- **Why it reads as AI:** filler before the answer. A human who knows
  the subject starts with the answer.
- **Before:** "Great question! In today's fast-paced world, ..."
- **After:** [the answer, directly].
- **THEN:** delete the opener; start with the answer.
- **Rule:** H-03.

### Hollow transitions

- **Pattern:** "Furthermore", "Moreover", "Additionally",
  "In conclusion", "It's important to note", "It's worth noting".
- **Why it reads as AI:** scaffolding that adds no meaning. If the
  paragraph needs "Furthermore" to connect, the connection is weak.
- **Before:** "Furthermore, it's important to note that the system
  is robust."
- **After:** "The system retries failed writes three times."
- **THEN:** delete the transition; IF the connection is weak THEN strengthen the sentence instead.
- **Rule:** Q-01.
