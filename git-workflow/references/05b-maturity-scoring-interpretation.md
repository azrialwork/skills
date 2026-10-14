<!--
  05b-maturity-scoring-interpretation.md -- Reference for git-workflow.

  Covers: how to interpret the maturity score after the rubric is
  applied: N/A renormalization (Step 2), encoded edge cases (Step 3),
  the scoring pseudocode (Step 4), and what remains human-judged.
  Companion: 05a-maturity-scoring-rubric.md (Steps 0-1: the rubric).
  Read after scoring, before reporting.
-->

# Maturity scoring - interpretation (Steps 2-4)

INPUT: the per-item scores from `05a-maturity-scoring-rubric.md`
(Steps 0-1). OUTPUT: the final score, band, and an auditable report.

Run Step 2, then Step 3, then Step 4, in order. Read this file after
scoring, before reporting.

## Step 2 - Renormalize N/A items

Rule: any item whose precondition does not exist is marked N/A and
excluded from BOTH numerator and denominator. Evaluate each:

- IF the repo is solo-dev THEN mark 3.3 (required approvals) and 3.6
  (CODEOWNERS) as N/A.
- IF the repo is solo direct-to-main trunk-based THEN mark 3.1-3.5 and
  3.7-3.8 as N/A (there are no PRs); 2.2 is satisfied by the
  `commit-msg` hook.
- IF the repo has no releases yet THEN mark all of Category 5 as N/A.
- IF the host is not GitHub THEN use the GitLab mappings in the
  rubric table (protected branches, MR approval rules, project
  merge-method setting, MR changes API, GitLab Releases).

Final score: `100 x earned_points / applicable_points`, rounded to the
nearest integer. ALWAYS list every N/A item in the report -- the list
is what keeps the score auditable.

## Step 3 - Edge cases (encoded, not footnoted)

1. **Squash-merge repos:** 2.1 is measured on integration-branch history,
   which already contains the squash messages (PR titles). 2.2 MUST be
   enforced at the PR title, not on branch commits -- the Conventional
   Commits spec FAQ explicitly allows maintainers to clean up messages at
   merge time, so linting branch commits in a squash workflow is wrong.
2. **Rebase-merge repos:** every commit must be clean on its own; lint
   branch commits via hook or CI.
3. **GitFlow repos:** 4.2 expects merge commits enabled (`--no-ff`
   preserves feature boundaries per Driessen); 1.4 expects `develop` to
   exist.
4. **Vague-subject false positives:** 2.3's probe is intentionally narrow
   (exact known-vague subjects). A human MAY override a flag with a
   stated reason.

## Step 4 - Pseudocode

```
select model via decision tree (references/01-branching-models.md)
applicable = []
for each item in categories 1..6:
    if item.precondition_missing(repo): mark N/A; continue
    applicable.append(item)
    item.score = probe(item)          # AUTO: run the command; HUMAN: record attestation
earned = sum(item.score for item in applicable)
max    = sum(item.points for item in applicable)
score  = round(100 * earned / max)
band   = band(score)
report(score, band, per-item evidence, N/A list)
```

## What remains human-judged (stated openly)

The following are attestations, because they describe team behavior
and intent, not repo state. The algorithm treats each attestation as a
checkable input: a named person confirms it. NEVER treat an
attestation as an assumption.

| Item | What the person confirms |
|---|---|
| 1.1 | The documented rationale for the model choice exists and is sound. |
| 2.4 | No silent breaking changes in the window. |
| 2.5 | Contributors sync before starting work and never start on a dirty main. |
| 3.6 | CODEOWNERS entries map to active contributors. |
| 4.1 | The merge-strategy rationale is documented and sound. |
| 5.5 | Release tags are never moved, deleted, or recreated. |

Out of scope for the 100 points (surface as review notes, never
scored): tone of release notes, quality of review comments, whether a
chosen model still fits a changed team.
