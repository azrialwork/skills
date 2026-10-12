<!--
  02-anti-slop-writing.md -- Reference for no-slop.

  The tiered rule set. Hard Gate rules are absolute (any violation is a
  FAIL). Purpose-Gate rules allow the technique but require a written
  reason. Quality Locks are consistency requirements. Follow while writing.
-->

# Anti-slop rules (tiered)

## Hard Gate -- absolute, no exceptions

Breaking any Hard Gate rule is a FAIL regardless of purpose.

### H-01 -- No fabricated specifics

- **FORBIDDEN:** numbers, statistics, names, dates, or quotes without
  a real source. If real data is not available, show no numbers at all.
- **Empty is better than deceptive.** A missing number is honest; an
  invented number is a lie that looks verified.
- Precision without provenance is the most dangerous slop.

### H-02 -- No em dash in generated text

- **FORBIDDEN:** the em dash character (`—`) in any generated text.
- Use a comma (`,`), period (`.`), colon (`:`), or parentheses instead.
- Text must feel natural and human; the em dash is the fastest
  lexical tell of synthetic prose.

### H-03 -- No sycophancy or throat-clearing

- **FORBIDDEN:** opening with agreement or filler: "Great question!",
  "You're absolutely right!", "As an AI", "Certainly!".
- Do not agree with the user as filler. If they are right, build on
  the point; if wrong, say so directly. Start with the answer.

### H-04 -- No invented sources

- **FORBIDDEN:** citing a source you did not actually read or open.
- Every factual claim must trace to something you can point at: a file
  you read, a tool result, a URL you opened. If you cannot name it, do
  not state it as fact.

## Purpose-Gate -- technique allowed, reason required

These techniques are tools, not crimes. Before using one, answer: **what
does this serve?** If the only answer is "it looks good" or "it fills
space", cut it. If the answer names clarity or structure, keep it and
the reason is written down (in your reasoning, not necessarily the text).

### P-01 -- Bullet lists

- Allowed for genuinely parallel items (steps, options, named lists).
- **Reason required** when the content would work as prose. Two
  sentences beat five thin bullets.

### P-02 -- Bold

- At most one bolded phrase per paragraph.
- It must mark the single thing the reader must not miss. If everything
  is emphasized, nothing is.

### P-03 -- Hedges (might, could, may, potentially)

- Allowed for genuine uncertainty. **FORBIDDEN** as evasion: a paragraph
  of hedges that avoids taking any position.

### P-04 -- Intensifiers (very, really, deeply, incredibly)

- Allowed only when the degree carries information ("deeply nested"
  tells you something; "very good" tells you nothing).

### P-05 -- Metaphors (landscape, navigate, journey, tapestry)

- Allowed only when the metaphor clarifies. **FORBIDDEN** as decoration:
  if removing the metaphor loses nothing, it was decoration.

## Quality Locks -- consistency

### Q-01 -- One idea per paragraph

- If a paragraph has no point, delete it. Deletion test: remove the
  sentence; if nothing is lost, it was slop.

### Q-02 -- Vary the structure

- No templated section shapes. If every section looks the same, break
  the pattern deliberately.

### Q-03 -- No decorative conclusion

- End when the content ends. Never restate everything under
  "In conclusion" or close with "Hope this helps!".

### Q-04 -- No emoji in professional text

- None. Not in headings, not as bullets, not for emphasis.

### Q-05 -- Specifics or silence

- Every claim gets a number, a name, a date, or an example -- or it
  gets cut. "Significant improvement" becomes "23% faster" or disappears.

## Before/after (the rules in action)

Slop: "In today's fast-paced digital landscape, it's important to note
that leveraging cutting-edge tools can truly revolutionize your
workflow. Furthermore, these robust solutions seamlessly unlock new
levels of productivity."
(Violations: H-01 has no evidence, P-05 decoration, P-04 padding,
Q-01 says nothing twice.)

Clean: "The new linter runs in 400ms instead of 3s, so it can run on
every save."
