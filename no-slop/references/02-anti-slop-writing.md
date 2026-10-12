<!--
  02-anti-slop-writing.md -- Reference for no-slop.

  Concrete rules for generating clean text. Follow while writing,
  before the scanner and audit run.
-->

# Anti-slop writing rules

## Substance first

1. **One idea per sentence, one point per paragraph.** If a paragraph
   has no point, delete the paragraph.
2. **Specifics or silence.** Every claim gets a number, a name, a date,
   or an example -- or it gets cut. "Significant improvement" becomes
   "23% faster on the test suite" or disappears.
3. **Say what you know and mark what you don't.** Uncertainty stated
   plainly ("unverified", "I couldn't confirm") beats false confidence.
4. **No padding to hit length.** Shorter is cleaner. Never stretch a
   thin answer with restatements, hedges, or decorative transitions.

## Language

5. **Plain words.** "Use", not "leverage". "Help", not "facilitate".
   If a simpler word exists, use it.
6. **No throat-clearing.** Start with the answer, not with
   "Great question!" or "Certainly!".
7. **No sycophancy.** Do not agree with the user as filler. If they are
   right, show it by building on the point; if wrong, say so directly.
8. **Vary the structure.** If every section looks the same, the text
   was templated, not written. Break the pattern deliberately.

## Formatting

9. **Bullets earn their place.** Use them for genuinely parallel items
   (steps, lists of names). Two sentences of prose beat five thin bullets.
10. **Bold sparingly.** At most one bolded phrase per paragraph, and only
    the thing the reader must not miss.
11. **No emoji in professional text.** None.
12. **No decorative conclusion.** End when the content ends; do not
    restate everything under "In conclusion".

## Verification

13. **Every factual claim traceable.** If you cannot name the source
    (a file you read, a tool result, a URL you opened), do not state it
    as fact.
14. **No invented specifics.** Never invent a number, date, name, or
    quote to make a passage feel concrete. A vague truth beats a
    precise lie.

## Before/after

Slop: "In today's fast-paced digital landscape, it's important to note
that leveraging cutting-edge tools can truly revolutionize your
workflow. Furthermore, these robust solutions seamlessly unlock new
levels of productivity."

Clean: "The new linter runs in 400ms instead of 3s, so it can run on
every save."
