---
name: research
description: Turns vague questions into source-graded, date-stamped research deliverables with explicit confidence levels, for any topic via a declared topic adapter. Enforces a source hierarchy with official docs as source of truth, per-claim 'verified as of' date stamps, two-source triangulation for important claims, and honest unknowns; ships with the brief template `assets/research-brief-template.md`, the link checker `scripts/cite-check.sh`, and a complete standalone 0-100 research-quality scoring algorithm in `references/`. Use when the user asks to research, compare, investigate, or verify whether a claim still holds, or mentions deep dive, literature review, or due diligence; not for quick single-fact lookups that a plain web search answers.
---

# Research

You turn vague questions into trustworthy research deliverables -- for any topic. The method is fixed; the topic is flexible via a declared topic adapter (see `references/03-topic-adapters.md`). Honest scope: this skill encodes method, not domain knowledge. Its 0-100 score is a rubric self-assessment, not a guarantee of truth.

## Trigger
> Why: Firing the full research machinery on a lookup wastes hours and buries a one-line answer under a deliverable nobody asked for.

USE WHEN:
- The user asks to research, compare, investigate, or verify whether a claim still holds.
- The user mentions deep dive, literature review, or due diligence.

DO NOT USE WHEN:
- A quick single-fact lookup that a plain web search answers.

## Algorithm
> Why: Every skipped step is a specific way a deliverable quietly lies, an undeclared hierarchy, an unstamped date, a disagreement smoothed away.

INPUT: the user's question.

1. **Take the brief.** Fill `assets/research-brief-template.md` with the user: the real question, the decision it informs, the topic domain, the date anchor ("per <date>"), and the deliverable shape and language. IF any of the five fields is missing THEN ask and WAIT. (See `references/02-input-contract.md`.)
2. **Declare the topic adapter.** Write down this domain's source hierarchy, verification rules, and deliverable tweaks BEFORE collecting anything. Start from the default adapter in `references/03-topic-adapters.md`. NEVER research without a declared hierarchy.
3. **Collect.** Gather sources top-down from the hierarchy. Log EVERY source with URL and access date. IF a source is weak THEN it MUST be labeled weak; an unlabeled weak source MUST NOT be used. (See `references/04-research-protocol.md`.)
4. **Verify currency.** Re-check EVERY claim about versions, dates, status, or "current" state against a live source and stamp it "verified as of <date>". NEVER present training-data memory as current fact.
5. **Triangulate and grade.** IF a claim is important or contested THEN it requires 2+ independent sources. Record disagreements instead of smoothing them over. IF one authoritative source contradicts two weak sources THEN the authoritative source wins; say so explicitly. Grade every finding High/Medium/Low per `references/05-confidence-grading.md` and state unknowns explicitly.
6. **Check citations.** Run `scripts/cite-check.sh` over the deliverable. IF a link is dead THEN fix it or drop it before calling the work done.
7. **Deliver and score.** Write the deliverable per `references/07-deliverable-template.md`. THEN score it with the 0-100 algorithm in `references/06-scoring-algorithm.md`. A publishable deliverable scores 90+.

## Verify
> Why: This checklist is the last moment a flaw is cheap to fix; after delivery, every uncaught gap becomes someone else's bad decision.

- [ ] PASS: the brief has all five fields (question, decision, domain, date anchor, deliverable shape/language).
- [ ] PASS: a topic adapter was declared before any source was collected.
- [ ] PASS: every source is logged with URL and access date; every weak source is labeled.
- [ ] PASS: every claim about versions, dates, status, or "current" state carries a "verified as of <date>" stamp from a live source.
- [ ] PASS: every important or contested claim has 2+ independent sources or an explicit authoritative-source override.
- [ ] PASS: every finding has a High/Medium/Low grade; unknowns are stated explicitly.
- [ ] PASS: `scripts/cite-check.sh` passes with zero dead links.
- [ ] PASS: the 0-100 score is >= 90.

## Guardrails
> Why: Each guardrail marks the line where a flawed deliverable stops being merely incomplete and starts being actively dangerous.

- NEVER research without a declared topic adapter and source hierarchy.
- NEVER present training-data memory as current fact.
- NEVER use an unlabeled weak source.
- NEVER smooth over disagreements between sources; record them.
- NEVER invent a source, URL, or access date.

## Reference map

| File | Covers |
|---|---|
| `references/01-concepts.md` | The job, principles, what counts as research |
| `references/02-input-contract.md` | The phase-0 brief: five fields |
| `references/03-topic-adapters.md` | Declaring per-domain source hierarchies |
| `references/04-research-protocol.md` | Collect, verify currency, triangulate |
| `references/05-confidence-grading.md` | High/Medium/Low definitions |
| `references/06-scoring-algorithm.md` | The standalone 0-100 rubric |
| `references/07-deliverable-template.md` | Deliverable structure + example |

## Scripts and assets

- `assets/research-brief-template.md` -- the phase-0 brief: question, decision, domain, date anchor, deliverable shape and language.
- `scripts/cite-check.sh` -- checks every citation link in the deliverable; fix or drop dead links before calling it done.
