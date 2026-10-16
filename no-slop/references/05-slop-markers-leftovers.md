<!--
  05-slop-markers-leftovers.md -- Reference for no-slop.

  Covers: leftover patterns -- knowledge disclaimers, document-about-
  itself, heading echoes, decorative headings, wrong-reader writing,
  adjective inflation, scenario openers, false ranges, empty closers.
  Part of the marker catalog; part A is
  01-slop-markers-lexical.md.
-->

# Slop patterns -- leftovers and wrong-reader writing

## Contents

- [Detection algorithm](#detection-algorithm)
- [Knowledge-limit disclaimers and speculative gap-filling](#knowledge-limit-disclaimers-and-speculative-gap-filling)
- [Writing about the document instead of its subject](#writing-about-the-document-instead-of-its-subject)
- [A heading repeated in the first sentence](#a-heading-repeated-in-the-first-sentence)
- [Decorative headings](#decorative-headings)
- [Re-explaining what the reader knows](#re-explaining-what-the-reader-knows)
- [Curly quotation marks (weak alone)](#curly-quotation-marks-weak-alone)
- [Real/actual adjective inflation](#realactual-adjective-inflation)
- [Speculative scenario openers](#speculative-scenario-openers)
- [False ranges](#false-ranges)
- [Generic future-narrative closers](#generic-future-narrative-closers)

Chat wrappers, drafting moves, and model limitations that were never
meant for the reader; text written for a reader who shares no context.

## Detection algorithm
> Why: Leftovers are drafting artifacts the reader was never meant to see. The detector scans in document order because these patterns leak everywhere.

INPUT: the draft text.

1. Scan against the patterns below, in document order.
2. IF a pattern is observed THEN record a finding with pattern name and Rule ID, and apply the THEN line.
3. The curly-quote marker is informational only: count it solely alongside other tells, never as a lone FAIL.

## Knowledge-limit disclaimers and speculative gap-filling
> Why: A gap admitted and then filled with a guess is worse than silence. The disclaimer launders the fabrication.

- **Pattern:** "As of my last update", "while details are limited",
  "based on available information", "she likely grew up in...".
- **Why it reads as AI:** the text admits a knowledge gap, then fills
  it with a plausible guess formatted as a statement.
- **THEN:** state what the source shows, or remove the sentence. NEVER turn missing information into a confident claim.
- **Rule:** H-01.

## Writing about the document instead of its subject
> Why: Text describing itself instead of its subject makes the reader do the author's job. They came for the thing, not the tour.

- **Pattern:** "This function was added to replace..."; "compiled
  from..."; "The table below compares..."; "In this article, we will
  explore...".
- **Why it reads as AI:** the text describes itself instead of its
  subject.
- **THEN:** describe the subject; state a convention only when the reader cannot see it.
- **Rule:** Q-01.

## A heading repeated in the first sentence
> Why: Restating the heading wastes the reader's first breath on the section. Start where the content starts.

- **Pattern:** "## Performance" followed by "Speed matters." before
  the real content begins.
- **Why it reads as AI:** restates the heading instead of starting.
- **THEN:** let the heading do the work; start the section at the content.
- **Rule:** Q-01.

## Decorative headings
> Why: Decoration applied by rule signals that every choice was automatic. The reader stops trusting the content too.

- **Pattern:** Title Case on every subheading; emojis or arrows in
  headings ("Strategic Negotiations And Partnerships", "Launch Phase:").
- **Why it reads as AI:** decoration applied by rule.
- **THEN:** use sentence case; remove emojis and arrows; name what the section holds.
- **Rule:** P-02.

## Re-explaining what the reader knows
> Why: In a thread, the reader already has the context. Re-explaining it buries the decision they came for.

- **Pattern:** in a reply, restating the problem, walking the full
  diagnosis, and burying the decision in the last line.
- **Why it reads as AI:** a model writes for a reader who shares no
  context. In a thread the reader already has it.
- **THEN:** lead with the decision; keep only the reasoning that would change agreement.
- **Rule:** Q-01.

## Curly quotation marks (weak alone)
> Why: Weak tells must stay weak. Treating them as verdicts is how filters start accusing innocent text.

- **Pattern:** "..." where the format calls for straight quotes.
- **Why it is weak:** most editors auto-curl, so one curly quote proves
  nothing. Informational only: count it alongside other tells, mainly
  in plain-text contexts (code comments, commit messages) where nothing
  auto-curls.
- **Rule:** Q-04 (informational).

## Real/actual adjective inflation
> Why: 'Real' with no named contrast implies everything else is fake. An accusation disguised as praise.

- **Pattern:** "real on-chain tokenomics", "genuine utility",
  "true product-market fit" -- with no named contrast.
- **Why it reads as AI:** implies the rest of the field is fake without
  saying what makes this instance real.
- **THEN:** drop the adjective, or name the contrast explicitly ("actual revenue from paying customers, not grants").
- **Rule:** Q-05.

## Speculative scenario openers
> Why: A hypothetical of desirable outcomes is a wish, not an argument. It spends the reader's imagination on nothing testable.

- **Pattern:** "Imagine a world where..."; "Picture a future in
  which...".
- **Why it reads as AI:** a hypothetical listing desirable outcomes
  stands in for an argument.
- **THEN:** cut the scene-setting; keep the claim at the same confidence the source supports.
- **Rule:** H-01.

## False ranges
> Why: False breadth pairs unrelated extremes to sound comprehensive. The reader gets scope without substance.

- **Pattern:** "from the Big Bang to dark matter";
  "from ancient civilizations to modern startups".
- **Why it reads as AI:** false breadth pairing unrelated extremes.
- **THEN:** list the actual topics, or pick the one that matters.
- **Rule:** Q-05.

## Generic future-narrative closers
> Why: A prediction with no testable content can never be wrong, which is exactly why it says nothing.

- **Pattern:** "may become one of the most important narratives of the
  next cycle"; "is poised to become the defining trend".
- **Why it reads as AI:** a prediction with no testable content.
- **THEN:** use a falsifiable version only when the source supplies it; otherwise cut.
- **Rule:** Q-03, H-01.
