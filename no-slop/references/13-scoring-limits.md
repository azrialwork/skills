<!--
  13-scoring-limits.md -- Reference for no-slop.

  Covers: what the algorithm cannot automate (named, required human or
  LLM-judge inputs) and calibration and reliability notes (current as of
  2026-10-13). Part D of the scoring algorithm; part A is
  10-scoring-algorithm.md.
-->
# Scoring algorithm -- limits and calibration (part D)

What the algorithm cannot automate, and calibration/reliability notes. The
algorithm spec is part A (`10-scoring-algorithm.md`).

## What cannot be automated (explicit)
> Why: Naming the limits is part of the algorithm. An honest filter states what it cannot see instead of pretending the script saw it.

The algorithm is complete because every non-mechanical check is a named,
required input -- but the following genuinely need a human or an
LLM-judge; the script will never do them:

- **H-01 provenance / H-04 source verification.** Detecting that a
  number *exists* is mechanical; verifying it was *actually read* is a
  process check. Needs the source ledger S or human attestation.
- **Q-01 deletion test, Q-02 template detection, Q-05 claim
  specificity.** Semantic judgments about redundancy, shape, and
  "specific enough".
- **All Purpose-Gate reasons.** "What does this serve?" is a reasoning
  step, not a measurement. The densities are the trigger; the reason is
  the verdict.
- **Liveliness (all three tests).** Counterfactual re-reading; no regex
  can do it. Approximable by an LLM-judge prompt or by specificity
  metrics (named-entity density), but the judgment is the check.
- **Novel H-03 forms.** The opener list covers known patterns; new
  sycophancy shapes need a reader.

## Calibration and reliability notes (current as of 2026-10-13)
> Why: Thresholds decay. Today's default is tomorrow's guess, so the notes say when to re-check, not just what to trust.

- Density ramps are anchored on practitioner heuristics: hedge density
  >= 6/1000w as high-signal, AI-vocab >= 15/1000w as high-signal, bullet
  ratio > 0.5 mirroring the scanner. They are defaults -- tune against
  labeled corpora and report precision/recall when you do.
- Statistical signals (perplexity, burstiness CV) are approximate,
  population-dependent, and never verdicts. Human sentence-length CV is
  often > 60, model output often < 30 -- but careful non-native writing
  clusters with model output on the same statistics. Liang et al.,
  *Patterns* 4(7):100779 (2023): seven detectors averaged 61.2% false
  positives on TOEFL essays by non-native writers (97.8% flagged by at
  least one detector) versus ~5% on native-speaker essays.
- Detector reliability, 2026: OpenAI retired its own classifier in July
  2023 for low accuracy; independent 2026 evaluations report large
  vendor-vs-independent accuracy gaps and near-zero reliability against
  lightly humanized text. Treat every external detector number as
  contested.
- **This score is a rubric for your own draft, not a detector for other
  people's writing and not proof of authorship.** NEVER accuse on
  statistics alone.
