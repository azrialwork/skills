<!--
  03-self-audit.md -- Reference for no-slop.

  Post-generation audit for what the scanner cannot see. Walk this
  checklist after slop-scan.sh passes.
-->

# Self-audit checklist

Run the scanner first (`scripts/slop-scan.sh`). Then walk this list --
it covers what heuristics cannot see.

## Deletion test

For each paragraph, delete it mentally. If the piece loses nothing,
delete it for real. Do this for sentences too. Slop hides in text
that survives on fluency alone.

## Specificity test

Highlight every factual claim. For each one, ask:
- Is there a number, name, date, or example attached?
- Can I point to where I got it (file, tool output, URL)?
- Did I invent any part of it to sound concrete?

Any "no" is a rewrite or a cut.

## Originality test

Could any model produce this from the same prompt without the specific
context I was given? If yes, the text adds nothing -- find the angle
only this context makes possible, or say less.

## Confidence test

Mark every statement that is uncertain, inferred, or unverified.
If none are marked but the topic has genuine uncertainty, false
confidence slipped in -- add the markers.

## Tone test

Read it aloud. Cut anything that sounds like a press release, a
motivational poster, or agreement-for-agreement's-sake. The remaining
text should sound like a competent human who knows the subject and
respects the reader's time.

## Sign-off

Only ship when: scanner passes, every flagged passage was rewritten
(not just de-worded), and this checklist has no open items. If an item
cannot be satisfied honestly, say so in the text rather than faking it.
