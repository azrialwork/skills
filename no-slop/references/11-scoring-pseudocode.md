<!--
  11-scoring-pseudocode.md -- Reference for no-slop.

  Covers: pseudocode implementing the five scoring steps (Hard Gate,
  Purpose-Gate deductions, Quality Lock deductions, liveliness ceiling,
  verdict). Part B of the scoring algorithm; part A is
  10-scoring-algorithm.md.
-->
# Scoring algorithm -- pseudocode (part B)

Executable-form summary of the five steps. The algorithm spec is part A
(`10-scoring-algorithm.md`).

## Pseudocode

```text
function score_text(T, S, J):            # J = human/judge inputs
    seg = segment(T)                    # W, sentences, paragraphs, lines

    # Step 1 -- Hard Gate
    if em_dash_present(T):                    return fail("H-02")
    if sycophancy_opener(seg.first_block):    return fail("H-03")
    for s in extract_specifics(T):
        if not resolves(s, S) and not J.h01_ok: return fail("H-01")
    for c in extract_citations(T):
        if not resolves(c, S) and not J.h04_ok: return fail("H-04")
    if not J.h03_ok_novel:                    return fail("H-03")

    # Step 2 -- Purpose-Gate
    score = 100
    score -= p01_deduction(seg) unless J.p01_reason_ok      # cap 8
    score -= p02_deduction(seg) unless J.p02_reason_ok      # cap 8
    score -= p03_deduction(seg) unless J.p03_reason_ok      # cap 8
    score -= p04_deduction(seg) unless J.p04_reason_ok      # cap 8
    score -= p05_deduction(seg) unless J.p05_reason_ok      # cap 8

    # Step 3 -- Quality Locks
    score -= q01_deduction(J.q01_fail_count)                # 0/2/4
    score -= q02_deduction(J.q02_level)                     # 0/2/4
    score -= q03_deduction(T)                               # 0/4
    score -= q04_deduction(T)                               # 0/4
    score -= q05_deduction(J.q05_count)                     # 0/2/4

    # Step 4 -- Liveliness ceiling
    if not (J.l1 and J.l2 and J.l3): score = min(score, 40)

    # Step 5 -- Verdict
    return clamp(score, 0, 100)
```

`scripts/slop-scan.sh` implements the mechanical subset of Steps 1-2
(phrase hits, density groups, structural heuristics, both hard fails)
plus informational burstiness; it is the floor the algorithm builds on.

