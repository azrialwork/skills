---
name: research
description: Turns vague questions into source-graded, date-stamped research deliverables with explicit confidence levels, for any topic via a declared topic adapter. Enforces a source hierarchy with official docs as source of truth, per-claim 'verified as of' date stamps, two-source triangulation for important claims, and honest unknowns; ships with the brief template `assets/research-brief-template.md`, the link checker `scripts/cite-check.sh`, and a complete standalone 0-100 research-quality scoring algorithm in `references/`. Use when the user asks to research, compare, investigate, or verify whether a claim still holds, or mentions deep dive, literature review, or due diligence; not for quick single-fact lookups that a plain web search answers.
---

<!--
  research/SKILL.md -- The research skill: turns vague questions into
  source-graded, date-stamped deliverables with explicit confidence levels.

  NOTE: the YAML frontmatter above must be the very first thing in this file.
  Parsers expect `---` at byte 0, so the repo header comment lives here,
  after the frontmatter block, not before it.
-->

# Research

You turn vague questions into trustworthy research deliverables -- for any
topic. The method is fixed; the topic is flexible via a declared topic
adapter (see `references/03-topic-adapters.md`).

## Workflow

1. **Take the brief.** Fill `assets/research-brief-template.md` with the user:
   the real question, the decision it informs, the topic domain, the date
   anchor ("per <date>"), and the deliverable shape and language. See
   `references/02-input-contract.md`.
2. **Declare the topic adapter.** Write down this domain's source hierarchy,
   verification rules, and deliverable tweaks *before* collecting anything.
   Start from the default adapter in `references/03-topic-adapters.md`.
   Never research without a declared hierarchy.
3. **Collect.** Gather sources top-down from the hierarchy. Log every source
   with URL and access date; weak sources are allowed only when labeled weak.
   See `references/04-research-protocol.md`.
4. **Verify currency.** Re-check every claim about versions, dates, status, or
   "current" state against a live source and stamp it "verified as of
   <date>". Never present training-data memory as current fact.
5. **Triangulate and grade.** Important or contested claims need 2+
   independent sources; record disagreements instead of smoothing them over.
   Grade every finding High/Medium/Low per
   `references/05-confidence-grading.md` and state unknowns explicitly.
6. **Check citations.** Run `scripts/cite-check.sh` over the deliverable;
   fix or drop dead links before calling it done.
7. **Deliver and score.** Write the deliverable per
   `references/07-deliverable-template.md`, then score it with the 0-100
   algorithm in `references/06-scoring-algorithm.md`. A publishable
   deliverable scores 90+.

## Reference map

- `references/01-concepts.md` -- the job, principles, what counts as research
- `references/02-input-contract.md` -- the phase-0 brief: five fields
- `references/03-topic-adapters.md` -- declaring per-domain source hierarchies
- `references/04-research-protocol.md` -- collect, verify currency, triangulate
- `references/05-confidence-grading.md` -- High/Medium/Low definitions
- `references/06-scoring-algorithm.md` -- the standalone 0-100 rubric
- `references/07-deliverable-template.md` -- deliverable structure + example

## Honest scope

This skill encodes method, not domain knowledge: it cannot verify a claim no
source covers, and its 0-100 score is a rubric self-assessment, not a
guarantee of truth. Heuristics (the 2-source rule, confidence levels) are
judgment aids -- one authoritative source can outrank two weak ones; say so
when it does.

Details live in `references/` -- consult the relevant file instead of guessing.
