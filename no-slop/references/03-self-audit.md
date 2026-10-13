<!--
  03-self-audit.md -- Reference for no-slop.

  Post-generation audit: the Delivery Gate plus the liveliness check.
  Walk this after slop-scan.sh passes. Covers what heuristics cannot see.
-->

# Self-audit and Delivery Gate

Run the scanner first (`scripts/slop-scan.sh`). Then walk this audit.
Nothing ships until every block passes.

## Block 1 -- Hard Gate (absolute)

Any H-rule violation is a FAIL. Fix it, no exceptions:

- [ ] H-01: every number, name, date, and quote has a real source
       (or no numbers appear at all).
- [ ] H-02: no em dash (`—`) anywhere in the text.
- [ ] H-03: no sycophancy opener, no throat-clearing.
- [ ] H-04: every cited source was actually read or opened.

## Block 2 -- Purpose-Gate (reason required)

For each P-technique used (bullets, bold, hedges, intensifiers,
metaphors):

- [ ] I can state what it serves (clarity, structure, honesty).
- [ ] "It looks good" / "it fills space" was not the reason.
- [ ] Anything without a reason was cut.

## Block 3 -- Liveliness (alive, not just clean)

Removing slop does not produce good text; it leaves a void. Liveliness
must be added, not assumed. A sterile result is a failure to fix.

- [ ] **Topic-swap test:** if the topic were swapped for another,
      would this text read the same? If yes, it is generic -- rewrite
      until only this topic could have produced it.
- [ ] **Specific-context test:** does the text carry names, situations,
      trade-offs, or constraints that only this context provides? If it
      could have been written without the context given, it adds nothing.
- [ ] **Voice test:** read it aloud. It should sound like a competent
      human who knows the subject and respects the reader's time -- not
      a press release, not a template.

## Block 4 -- Quality Locks and substance

- [ ] Q-01: deletion test -- every surviving paragraph earns its place.
- [ ] Q-02: structure varies; no templated section shapes.
- [ ] Q-03: ends when the content ends; no decorative conclusion.
- [ ] Q-04: no emoji.
- [ ] Q-05: every claim has specifics or was cut.
- [ ] No invented specifics anywhere (re-verify H-01 after edits --
      fixes often smuggle in new unverified claims).

## Sign-off

Ship only when all four blocks pass. If a block cannot be satisfied
honestly, say so in the text rather than faking it. A fix that adds
new unverified claims restarts the audit at Block 1.

## Scoring the audit (0-100)

The four blocks above are also a scoring algorithm
(full spec: `references/04-scoring-algorithm.md`):

1. **Hard Gate (Block 1)** is binary: any H-rule failure -> score 0.
2. **Purpose-Gate (Block 2)**: start at 100; each unjustified P-rule
   costs up to 8 points by density (P-01..P-05, max 40 total).
3. **Quality Locks (Block 4)**: each failed lock costs 0, 2, or 4
   points (max 20 total).
4. **Liveliness (Block 3)** is a ceiling, not a deduction: failing any
   of the three tests caps the score at 40 -- sterile-but-clean is a
   failure to fix, not a pass.
5. **PASS at 80+.** A perfectly clean, lively text scores exactly 100.

`scripts/slop-scan.sh` automates the mechanical subset (phrase hits,
density groups, structural heuristics, hard fails, burstiness as info).
Everything it cannot see -- H-01/H-04 provenance, the P-rule reasons,
Q-01/Q-02/Q-05 judgment, all of liveliness -- is an explicit human or
LLM-judge input to the algorithm. Nothing is silently omitted.
