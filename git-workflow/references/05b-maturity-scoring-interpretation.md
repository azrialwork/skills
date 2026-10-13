<!--
  05b-maturity-scoring-interpretation.md -- Reference for git-workflow.

  Covers: how to interpret the maturity score after the rubric is
  applied: N/A renormalization (Step 2), encoded edge cases (Step 3),
  the scoring pseudocode (Step 4), and what remains human-judged.
  Companion: 05a-maturity-scoring-rubric.md (Steps 0-1: the rubric).
  Read after scoring, before reporting.
-->
# Maturity scoring - interpretation (Steps 2-4)

Continuation of `05a-maturity-scoring-rubric.md`: apply the rubric first, then renormalize, handle edge cases, and combine per the pseudocode before reporting.
## Step 2 - Renormalize N/A items

Any item whose precondition does not exist is marked N/A and excluded
from both numerator and denominator:

- Solo-dev repos: 3.3 (required approvals) and 3.6 (CODEOWNERS) are N/A.
- Solo direct-to-main trunk-based: PR-gated items 3.1-3.5 and 3.7-3.8 are
  N/A (there are no PRs); 2.2 is satisfied by the `commit-msg` hook.
- Repos with no releases yet: all of Category 5 is N/A.
- Non-GitHub hosts: use the GitLab mappings in the table (protected
  branches, MR approval rules, project merge-method setting, MR changes
  API, GitLab Releases).

Final score: `100 x earned_points / applicable_points`, rounded to the
nearest integer. List every N/A item in the report so the score stays
auditable.

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
   (exact known-vague subjects). A human may override a flag with a reason.

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

- 1.1 (the documented *rationale* for the model choice), 2.4 (no silent
  breaking change), 2.5 (sync habit), 3.6 (CODEOWNERS currency), 4.1
  (strategy rationale), 5.5 (tag immutability): these are attestations,
  because they describe team behavior and intent, not repo state. The
  algorithm treats an attestation as a checkable input (a named person
  confirms it), never as an assumption.
- Tone of release notes, quality of review comments, and whether a
  chosen model still fits a changed team: judgment calls outside the
  100 points, surfaced as review notes, not scored.
