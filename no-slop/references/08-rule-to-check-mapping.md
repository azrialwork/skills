<!--
  08-rule-to-check-mapping.md -- Reference for no-slop.

  Covers: the rule-to-check mapping for the 0-100 scoring algorithm --
  mechanical probes (regex, count, density formula with threshold) or
  explicit judge inputs for every H/P/Q rule and liveliness.
  Part B of the tiered rules; part A is 07-anti-slop-rules.md.
-->
# Rule-to-check mapping -- mechanical probes and judge inputs (part B)

Part B of the tiered rules: how each rule maps to a check for the 0-100
algorithm. The rules themselves are part A (`07-anti-slop-rules.md`).

## Rule-to-check mapping (for the 0-100 algorithm)

Reading rule: every rule below maps to exactly one check. Run the check;
IF it is a mechanical probe THEN apply the formula; IF it is a judge
input THEN supply the named input -- never silently omit it.
Full algorithm: `references/10-scoring-algorithm.md`.

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
  significance-inflation, Tier 1A, and Tier 1B patterns in
  `assets/slop-phrases.txt` (@shots section). Density >= 15 -> 8;
  >= 5 -> 4; below 5 -> 0. The `vague-praise` and `boilerplate`
  density groups (`@density:vague-praise`, `@density:boilerplate`)
  use the standard density ramp (>= 12 -> 8; >= 6 -> 5; >= 2 -> 2)
  and feed the same P-05 deduction, capped at 8 combined.
- **P-05 cluster probe (mechanical, scanner-level)** -- Tier 2 rule:
  2+ DISTINCT `@cluster:tier2` words inside one paragraph -> +3 per
  paragraph in `slop-scan.sh`. Reported as a floor signal; the
  Delivery Gate decides.

### Extension modules -- checklist probes

Modules 05 and 06 carry their own checklists instead of numeric
rules. For the 0-100 algorithm they map to judge inputs:

- **05 code comments** -- judge: count of checklist items failing.
  0 -> 0; 1-2 -> 2; 3+ -> 4 (same band as a Quality Lock).
- **06 UI patterns** -- judge: count of checklist items failing.
  0 -> 0; 1-3 -> 2; 4+ -> 4. UI-copy tells (buzzwords, aphoristic
  cadence, theater framing, em-dash saturation) score under P-05,
  Q-02, Q-01, H-02 respectively.

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
