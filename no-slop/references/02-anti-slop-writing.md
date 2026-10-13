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

## Rule-to-check mapping (for the 0-100 algorithm)

Every rule below maps to exactly one check: a **mechanical probe**
(exact regex, count, or density formula with threshold) or an explicit
**judge input** (human or LLM-judge rubric -- never silently omitted).
Full algorithm: `references/04-scoring-algorithm.md`.

### Hard Gate -- mechanical probes + required attestations

- **H-01** -- Mechanical: extract candidate specifics with
  `[0-9]+(%|x\b|ms|s\b|ms\b)?` (numbers), `"[^"]{8,}"` (quotes), and
  `[A-Z][a-z]+ [A-Z][a-z]+` (named entities); each must resolve to an
  entry in the source ledger S. Required input: `S` (list of sources
  actually consulted) or human attestation `h01_ok` (bool). Any
  unresolvable specific -> score 0.
- **H-02** -- Mechanical, exact: `U+2014` present anywhere -> score 0.
  (`slop-scan.sh`: +50 hard fail.)
- **H-03** -- Mechanical: first non-empty block matches
  `great question|excellent question|as an ai|certainly!|fantastic point|
  you're right|you are right|absolutely` (case-insensitive) -> score 0.
  (`slop-scan.sh`: +50 hard fail.) Novel sycophancy forms -> judge input
  `h03_ok` (bool).
- **H-04** -- Mechanical: citation-shaped strings
  (`[Author, Year]`, `http(s)://`, `"Title"`, `doi:`) must resolve to an
  entry in S. Required input: `S` or human attestation `h04_ok` (bool).
  Any unresolvable citation -> score 0.

### Purpose-Gate -- density probes + reason override

Each P-rule: start from the mechanical density below; a stated, valid
reason (judge/human input `pXX_reason_ok`) waives that rule's deduction.
Deduction caps at 8 per rule. W = word count.

- **P-01** -- `bullet_ratio = bullet_lines / non_empty_lines`
  (bullet line: `^[ \t]*[-*][ \t]`). Ratio > 0.5 -> 8; 0.3-0.5 -> 4;
  below 0.3 -> 0.
- **P-02** -- `bold_spans` = count of `**...**` pairs; per-paragraph max.
  Any paragraph with > 1 span, or total spans > 10 -> 8; 2-10 spans
  total -> 4; 0-1 -> 0.
- **P-03** -- `hedge_density = hedge_hits / W * 1000`, hedge list:
  `might, could, may, potentially, possibly` (word-boundary). Density
  >= 12 -> 8; >= 6 -> 5; >= 2 -> 2; below 2 (or fewer than 2 hits) -> 0.
- **P-04** -- `intensifier_density`, list: `very, really, truly,
  incredibly, extremely`. Same ramp as P-03.
- **P-05** -- `aivocab_density`, list: the cliche-metaphor, hype-verb,
  and significance-inflation patterns in `assets/slop-phrases.txt`
  (delve, tapestry, robust, seamless, cutting-edge, pivotal moment,
  ...). Density >= 15 -> 8; >= 5 -> 4; below 5 -> 0.

### Quality Locks -- mixed probes and judge rubrics

Each Q-rule scored 0, 2, or 4 (max 4 per rule).

- **Q-01** -- Judge input: count of paragraphs failing the deletion
  test. 0 -> 0; 1-2 -> 2; 3+ -> 4.
- **Q-02** -- Judge input: templated section shapes present?
  none -> 0; mild repetition -> 2; mechanical skeleton -> 4.
- **Q-03** -- Mechanical: matches `in conclusion|in summary|
  hope this helps|let me know if you need` -> 4, else 0.
- **Q-04** -- Mechanical: any byte outside `[ -~]` (POSIX `[^ -~]`
  under `LC_ALL=C`) outside fenced code blocks -> 4, else 0.
- **Q-05** -- Judge input (heuristic assist: sentences containing
  evaluative adjectives -- significant, robust, seamless, dramatic --
  with no number, name, date, or example): 0 such sentences -> 0;
  1-2 -> 2; 3+ -> 4.

### Liveliness -- judge inputs, applied as a ceiling

- **L-1 topic-swap**, **L-2 specific-context**, **L-3 voice** (read
  aloud): three booleans. Any false -> final score capped at 40
  (`score = min(score, 40)`), regardless of deductions.
- Advanced informational signals (never scored alone): burstiness
  (sentence-length CV: < 30 uniform/AI-like, > 60 varied/human-like --
  reported by `slop-scan.sh`); perplexity/burstiness vendor thresholds
  are approximate and population-dependent, never verdicts.
