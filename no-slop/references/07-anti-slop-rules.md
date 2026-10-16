<!--
  07-anti-slop-rules.md -- Reference for no-slop.

  Covers: the tiered rule set -- Hard Gate (absolute), Purpose-Gate
  (technique allowed with a stated reason), Quality Locks (consistency) --
  plus before/after examples. Part A; the rule-to-check mapping is part B
  (08-rule-to-check-mapping.md). Follow while writing.
-->
# Anti-slop rules -- the tiered rule set (part A)

## Contents

- [Verdict algorithm](#verdict-algorithm)
- [Hard Gate -- absolute, no exceptions](#hard-gate----absolute-no-exceptions)
  - [H-01 -- No fabricated specifics](#h-01----no-fabricated-specifics)
  - [H-02 -- No em dash in generated text](#h-02----no-em-dash-in-generated-text)
  - [H-03 -- No sycophancy or throat-clearing](#h-03----no-sycophancy-or-throat-clearing)
  - [H-04 -- No invented sources](#h-04----no-invented-sources)
- [Purpose-Gate -- technique allowed, reason required](#purpose-gate----technique-allowed-reason-required)
  - [P-01 -- Bullet lists](#p-01----bullet-lists)
  - [P-02 -- Bold](#p-02----bold)
  - [P-03 -- Hedges (might, could, may, potentially)](#p-03----hedges-might-could-may-potentially)
  - [P-04 -- Intensifiers (very, really, deeply, incredibly)](#p-04----intensifiers-very-really-deeply-incredibly)
  - [P-05 -- Metaphors (landscape, navigate, journey, tapestry)](#p-05----metaphors-landscape-navigate-journey-tapestry)
- [Quality Locks -- consistency](#quality-locks----consistency)
  - [Q-01 -- One idea per paragraph](#q-01----one-idea-per-paragraph)
  - [Q-02 -- Vary the structure](#q-02----vary-the-structure)
  - [Q-03 -- No decorative conclusion](#q-03----no-decorative-conclusion)
  - [Q-04 -- No emoji in professional text](#q-04----no-emoji-in-professional-text)
  - [Q-05 -- Specifics or silence](#q-05----specifics-or-silence)
- [Before/after (the rules in action)](#beforeafter-the-rules-in-action)

Part A: the rules themselves. The rule-to-check mapping (mechanical probes
and judge inputs per rule) is part B (`08-rule-to-check-mapping.md`).

## Verdict algorithm
> Why: A verdict without an order is a negotiation. The hard gate runs first because a fatal flaw can never be outweighed by polish.

INPUT: the draft text.

1. Check every H-rule below. IF any H-rule is violated THEN verdict = FAIL, STOP. No exceptions, regardless of purpose.
2. For each P-technique used: IF you can state what it serves (clarity, structure, honesty -- written in your reasoning) THEN keep it; ELSE cut it.
3. Check every Q-lock below. IF a lock fails THEN apply its THEN line.
4. Verdict = PASS only when all three steps pass.

## Hard Gate -- absolute, no exceptions
> Why: Absolute lines exist because the alternative is a debate you will lose to your own deadline. Some boundaries must be drawn before the work starts.

### H-01 -- No fabricated specifics

- **FORBIDDEN:** numbers, statistics, names, dates, or quotes without
  a real source.
- **THEN:** IF real data is not available THEN show no numbers at all. A missing number is honest; an invented number is a lie that looks verified.
- Precision without provenance is the most dangerous slop.

### H-02 -- No em dash in generated text

- **FORBIDDEN:** the em dash character (U+2014) in any generated text.
- **THEN:** use a comma (`,`), period (`.`), colon (`:`), or parentheses instead.

### H-03 -- No sycophancy or throat-clearing

- **FORBIDDEN:** opening with agreement or filler: "Great question!",
  "You're absolutely right!", "As an AI", "Certainly!".
- **THEN:** start with the answer. IF the user is right THEN build on the point; IF wrong THEN say so directly.

### H-04 -- No invented sources

- **FORBIDDEN:** citing a source you did not actually read or open.
- **THEN:** every factual claim must trace to something you can point at: a file you read, a tool result, a URL you opened. IF you cannot name it THEN do not state it as fact.

## Purpose-Gate -- technique allowed, reason required
> Why: Banning every technique would trade one monotony for another. The question is never the tool, it is what the tool serves.

Before using one, answer: **what does this serve?** IF the only answer is "it looks good" or "it fills space" THEN cut it. IF the answer names clarity or structure THEN keep it, and write the reason down (in your reasoning, not necessarily the text).

### P-01 -- Bullet lists

- Allowed for genuinely parallel items (steps, options, named lists).
- **THEN:** IF the content would work as prose THEN use prose. Two sentences beat five thin bullets.

### P-02 -- Bold

- **THEN:** at most one bolded phrase per paragraph, marking the single thing the reader must not miss. IF everything is emphasized THEN nothing is: cut until one remains.

### P-03 -- Hedges (might, could, may, potentially)

- Allowed for genuine uncertainty.
- **FORBIDDEN** as evasion: **THEN:** IF a paragraph of hedges avoids taking any position THEN cut it or take the position the source supports.

### P-04 -- Intensifiers (very, really, deeply, incredibly)

- **THEN:** allowed only when the degree carries information ("deeply nested" tells you something; "very good" tells you nothing). IF it tells nothing THEN cut it.

### P-05 -- Metaphors (landscape, navigate, journey, tapestry)

- **THEN:** allowed only when the metaphor clarifies. IF removing the metaphor loses nothing THEN it was decoration: cut it.

## Quality Locks -- consistency
> Why: Consistency is what survives after the flashy flaws are fixed. Readers trust text that behaves the same way twice.

### Q-01 -- One idea per paragraph

- **THEN:** run the deletion test on every sentence: remove it; IF nothing is lost THEN it was slop -- keep it deleted.

### Q-02 -- Vary the structure

- **THEN:** IF every section shares the same shape THEN break the pattern deliberately.

### Q-03 -- No decorative conclusion

- **THEN:** end when the content ends. NEVER restate everything under "In conclusion" or close with "Hope this helps!".

### Q-04 -- No emoji in professional text

- **THEN:** none. Not in headings, not as bullets, not for emphasis.

### Q-05 -- Specifics or silence

- **THEN:** every claim gets a number, a name, a date, or an example -- or it gets cut. "Significant improvement" becomes "23% faster" or disappears.

## Before/after (the rules in action)
> Why: Abstract rules stay abstract. One concrete rewrite teaches more than a page of definitions.

Slop: "In today's fast-paced digital landscape, it's important to note
that leveraging cutting-edge tools can truly revolutionize your
workflow. Furthermore, these robust solutions seamlessly unlock new
levels of productivity."
(Violations: H-01 has no evidence, P-05 decoration, P-04 padding,
Q-01 says nothing twice.)

Clean: "The new linter runs in 400ms instead of 3s, so it can run on
every save."
