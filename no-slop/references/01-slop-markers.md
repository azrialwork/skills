<!--
  01-slop-markers.md -- Reference for no-slop.

  The catalog of AI slop markers: lexical, structural, and substance.
  Read before generating any non-trivial text.
-->

# Slop markers

## Lexical markers (words and phrases)

These words are not banned in themselves -- they are *markers*: their
density in a passage predicts slop. One occurrence is style; five is slop.

**Throat-clearing openers:** "Great question!", "Excellent question!",
"As an AI", "Certainly!", "Absolutely!"

**Empty intensifiers:** "very", "really", "truly", "deeply",
"incredibly", "extremely" (stacked, adding no information).

**Cliche metaphors:** "delve", "tapestry", "landscape" (as in "the ...
landscape"), "navigate" (as in "navigate the complexities"),
"embark", "bustling", "vibrant", "testament to".

**Hollow transitions:** "Furthermore", "Moreover", "Additionally",
"In conclusion", "In summary", "Overall,", "It's important to note",
"It's worth noting", "In today's fast-paced world",
"In today's digital age".

**Hype verbs:** "revolutionize", "game-changer", "cutting-edge",
"unlock" (as in "unlock the power"), "elevate", "seamless",
"robust" (as default adjective), "leverage" (when "use" would do).

**Hedge stacks:** "might", "could", "may", "potentially", "possibly"
-- one hedge is honesty; a paragraph of hedges is evasion.

The full machine-checkable list lives in
`assets/slop-phrases.txt`; extend it when you find new markers.

## Structural markers

- **Bullet-list everything:** a wall of bullets where two sentences
  would do. Bullets are for parallel items, not for hiding thin content.
- **Bold spam:** every other phrase wrapped in `**bold**`. Bold marks
  the one thing that matters per paragraph, not everything.
- **Emoji in professional text:** decorative emoji in docs, reports,
  or READMEs.
- **Formulaic restatement endings:** a final paragraph that restates
  the whole piece ("In conclusion, ...") without adding anything.
- **Sycophancy:** "You're absolutely right!", "That's a fantastic
  point!" -- agreement as filler before the actual answer.
- **Template skeletons:** identical section shapes repeated
  mechanically (every section: intro sentence, three bullets, summary).

## Substance markers (what scanners cannot see)

- **Verbose nothing-burgers:** long passages that survive deletion
  without losing information. Test: delete the sentence; if nothing is
  lost, it was slop.
- **Generic claims with no specifics:** no numbers, no names, no dates,
  no examples. "Many experts agree" -- which experts? "Significant
  improvement" -- how much?
- **False confidence:** stating uncertain things as fact; no
  uncertainty where uncertainty exists.
- **Repetition in disguise:** the same point reworded three times
  across three paragraphs.
- **No original angle:** pure regurgitation that any model would
  produce from the same prompt. If the text could have been written
  without the specific context given, it adds nothing.

## The one-line test

Read the passage aloud. If it sounds like a press release, a LinkedIn
influencer, or a model completing a prompt -- it is slop. Rewrite it
until it sounds like a competent human who knows the subject.
