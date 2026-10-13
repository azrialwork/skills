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

## Empirical grounding (why these markers, and their limits)

The marker list above is not folk wisdom. Kobak et al., "Delving into
LLM-assisted writing in biomedical publications through excess
vocabulary", *Science Advances* 11, eadt3813 (2025), analyzed 15M+
PubMed abstracts (2010-2024) with an excess-word method: words whose
frequency jumped abruptly after ChatGPT's release, beyond their
pre-2023 trend. They estimate at least 13.5% of 2024 abstracts were
processed with LLMs (up to 40% in some subcorpora), and the excess
shifted from content nouns to style words -- verbs and adjectives like
*delve, showcase, pivotal, underscore, meticulous, intricate*. A 2026
follow-up confirmed the markers persisted into 2025 full texts.

Limits you must respect (current as of 2026-10-13):

- **Word lists decay.** The human baseline is drifting toward AI
  vocabulary, so single-word tells weaken over time. Durable detection
  rests on structure, stance, and specificity -- not banned-word lists.
  The scanner is the floor for exactly this reason.
- **Detectors are unreliable as verdicts.** OpenAI shut down its own AI
  classifier in July 2023 citing low accuracy. Liang et al., "GPT
  detectors are biased against non-native English writers", *Patterns*
  4(7):100779 (2023), found seven widely-used detectors misclassified
  an average of 61.2% of TOEFL essays by non-native writers as
  AI-generated (97.8% flagged by at least one detector), versus ~5% on
  native-speaker essays -- careful, constrained writing trips the same
  statistical signals. Independent 2026 evaluations continue to show
  large vendor-vs-independent accuracy gaps and near-zero reliability
  against lightly humanized text.
- **Never accuse on statistics alone.** This skill scores *your own
  draft* against its rules. It is not a detector for other people's
  writing, and its score is a rubric -- not proof of authorship.
