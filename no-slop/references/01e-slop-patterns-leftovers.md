<!--
  01e-slop-patterns-leftovers.md -- Reference for no-slop.

  Covers: leftover patterns -- knowledge disclaimers, document-about-
  itself, heading echoes, decorative headings, wrong-reader writing,
  adjective inflation, scenario openers, false ranges, empty closers.
  Curated from blader/humanizer (MIT) and
  conorbronsdon/avoid-ai-writing (MIT) -- see SOURCES.md. Part of the
  marker catalog; part A is 01a-slop-markers-lexical.md.
-->

# Slop patterns -- leftovers and wrong-reader writing

Chat wrappers, drafting moves, and model limitations that were never
meant for the reader; text written for a reader who shares no context.

## Knowledge-limit disclaimers and speculative gap-filling

- **Pattern:** "As of my last update", "while details are limited",
  "based on available information", "she likely grew up in...".
- **Why it reads as AI:** the text admits a knowledge gap, then fills
  it with a plausible guess formatted as a statement. State what the
  source shows, or remove the sentence. Never turn missing information
  into a confident claim.
- **Rule:** H-01.

## Writing about the document instead of its subject

- **Pattern:** "This function was added to replace..."; "compiled
  from..."; "The table below compares..."; "In this article, we will
  explore...".
- **Why it reads as AI:** the text describes itself instead of its
  subject. Describe the subject; state a convention only when the
  reader cannot see it.
- **Rule:** Q-01.

## A heading repeated in the first sentence

- **Pattern:** "## Performance" followed by "Speed matters." before
  the real content begins.
- **Why it reads as AI:** restates the heading instead of starting.
  Let the heading do the work.
- **Rule:** Q-01.

## Decorative headings

- **Pattern:** Title Case on every subheading; emojis or arrows in
  headings ("Strategic Negotiations And Partnerships", "Launch Phase:").
- **Why it reads as AI:** decoration applied by rule. Use sentence
  case; remove emojis and arrows; name what the section holds.
- **Rule:** P-02.

## Re-explaining what the reader knows

- **Pattern:** in a reply, restating the problem, walking the full
  diagnosis, and burying the decision in the last line.
- **Why it reads as AI:** a model writes for a reader who shares no
  context. In a thread the reader already has it. Lead with the
  decision; keep only the reasoning that would change agreement.
- **Rule:** Q-01.

## Curly quotation marks (weak alone)

- **Pattern:** "..." where the format calls for straight quotes.
- **Why it is weak:** most editors auto-curl, so one curly quote proves
  nothing. Count it only alongside other tells, mainly in plain-text
  contexts (code comments, commit messages) where nothing auto-curls.
- **Rule:** Q-04 (informational).

## Real/actual adjective inflation

- **Pattern:** "real on-chain tokenomics", "genuine utility",
  "true product-market fit" -- with no named contrast.
- **Why it reads as AI:** implies the rest of the field is fake without
  saying what makes this instance real. Drop the adjective, or name
  the contrast explicitly ("actual revenue from paying customers,
  not grants").
- **Rule:** Q-05.

## Speculative scenario openers

- **Pattern:** "Imagine a world where..."; "Picture a future in
  which...".
- **Why it reads as AI:** a hypothetical listing desirable outcomes
  stands in for an argument. Cut the scene-setting; keep the claim at
  the same confidence the source supports.
- **Rule:** H-01.

## False ranges

- **Pattern:** "from the Big Bang to dark matter";
  "from ancient civilizations to modern startups".
- **Why it reads as AI:** false breadth pairing unrelated extremes.
  List the actual topics, or pick the one that matters.
- **Rule:** Q-05.

## Generic future-narrative closers

- **Pattern:** "may become one of the most important narratives of the
  next cycle"; "is poised to become the defining trend".
- **Why it reads as AI:** a prediction with no testable content. Use a
  falsifiable version only when the source supplies it; otherwise cut.
- **Rule:** Q-03, H-01.
