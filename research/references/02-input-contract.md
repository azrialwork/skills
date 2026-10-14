<!--
  02-input-contract.md -- Reference for research.

  Covers: the phase-0 brief -- the five fields that must be settled before
  research starts, with examples and pushback rules.
-->

# The input contract

INPUT: the user's raw request. OUTPUT: a filled brief (see `assets/research-brief-template.md`).

Algorithm -- fill all five fields BEFORE collecting anything:

1. **The real question.** Write the question as asked, then the sharpened version ("Is X good?" -> "should we adopt X for purpose P under constraints C?"). IF the question is really a lookup THEN STOP: answer directly, do not research.
2. **The decision it informs.** Name the decision and its stakes. IF there is no decision THEN write "exploratory -- no decision": the deliverable is exploratory and scored accordingly. IF the decision is unclear AND the stakes seem high THEN ask before proceeding.
3. **The topic domain.** Write one phrase (e.g. "JavaScript build tools"). This selects the topic adapter (see `03-topic-adapters.md`).
4. **The date anchor.** Write "Per <YYYY-MM-DD>" (usually today). Every currency-sensitive claim is verified against this date, never against training-data memory.
5. **Deliverable shape and language.** Default: structured writeup in the user's language (executive summary, findings, disagreements, limitations, sources -- see `07-deliverable-template.md`). IF the user wants anything else (slides, table-only, a different language) THEN agree on it now.

Gate: IF any field is empty THEN ask the user and WAIT. Do not start collecting until all five are filled.

## Pushback rules

- IF the domain has no identifiable authoritative sources THEN warn that confidence caps at Medium and confirm before proceeding.
- IF the decision is unclear and the stakes seem high THEN ask.
