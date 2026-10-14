<!--
  07-deliverable-template.md -- Reference for research.

  Covers: the default deliverable structure and a per-finding format,
  with a small example.
-->

# Deliverable template

Write in the user's language unless the brief says otherwise.

## Assembly algorithm

1. **Executive summary** (3-6 sentences): the answer, the confidence, and what would change it. IF the answer is "unknown" THEN the first sentence says "unknown".
2. **Findings**: one block per sub-question, using the per-finding format below.
3. **Disagreements**: where sources conflict, both sides cited. IF no disagreements exist THEN write "none recorded".
4. **Limitations and unknowns**: what could not be verified and why. Never leave this section empty: IF everything was verified THEN write "none".
5. **Sources**: every source with URL and access date.

## Per-finding format

```markdown
### <Sub-question>

**Answer:** <one paragraph>
**Confidence:** High/Medium/Low -- <why this grade>
**Sources:** <citation> (accessed <date>)
**Verified as of:** <date>
```

## Small example

```markdown
### Is library X still maintained? (per 2026-10-14)

**Answer:** No. The repository was archived on 2026-08-02 and the
last release was 2026-07-15.
**Confidence:** High -- official repository state, checked today.
**Sources:** github.com/org/x (accessed 2026-10-14)
**Verified as of:** 2026-10-14
```

## Honesty gates

- IF the answer is "unknown" THEN the summary's first sentence says "unknown".
- NEVER bury a Low-confidence finding in confident prose; its grade travels with it.
