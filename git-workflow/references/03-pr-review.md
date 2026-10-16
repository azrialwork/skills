<!--
  03-pr-review.md -- Reference for git-workflow.

  The pull-request review loop: branch protection (classic rules and
  the newer Rulesets), CODEOWNERS, merge queues, merge strategies, and
  review discipline. Current as of 2026-10-13. Read when setting up
  team collaboration on a repo.
-->

# PR and review workflow

## Contents

- [The loop](#the-loop)
- [Branch protection (GitHub)](#branch-protection-github)
- [Merge queues (advanced)](#merge-queues-advanced)
- [CODEOWNERS](#codeowners)
- [Merge strategies (pick exactly one per project, stay consistent)](#merge-strategies-pick-exactly-one-per-project-stay-consistent)
- [Review discipline](#review-discipline)

## The loop
> Why: Reviews only work when the PR is the single place where code, discussion, and CI meet; scatter them and context dies.

1. Branch from the integration branch (`main` in GitHub Flow).
2. Push early. IF the branch is not ready for review THEN open the
   pull request as a draft.
3. CI runs on the PR. Review happens on the PR. Discussion happens on
   the PR. The PR is the unit of collaboration.
4. Merge with the project's chosen strategy, then delete the branch.

## Branch protection (GitHub)
> Why: Branch protection is the difference between a policy everyone follows and a policy everyone remembers after the damage.

Selection: IF one policy must cover many branches THEN use Rulesets
(Settings -> Rules, the newer layered mechanism). ELSE classic branch
protection rules (Settings -> Branches) or Rulesets both satisfy the
checklist below.

Minimum useful checklist -- verify each item PASS with
`gh api repos/{owner}/{repo}/branches/main/protection`:

1. Pull request required before merging (no direct pushes).
2. Status checks required to pass; branches required to be up to date
   before merging (the check runs against the code that will land).
3. At least one approving review required (team repos).
4. Stale PR approvals dismissed when new commits are pushed.
5. Review from Code Owners required (when CODEOWNERS exists).
6. Conversation resolution required before merging.
7. Force pushes and branch deletions blocked on shared branches.
8. No bypassing the above settings (no admin bypass unless a
   documented emergency escape hatch exists).

Optional: require linear history. IF the strategy is squash or rebase
THEN linear history MAY be required; IF the strategy is merge-commit
THEN it MUST NOT be (linear history forbids merge commits).

Note: the protection API replaces the whole rule on write. WHEN
writing protection via the API THEN include the full rule; partial
payloads silently drop omitted settings.

## Merge queues (advanced)
> Why: On a busy repo, rebase churn burns more reviewer hours than any feature is worth.

IF "require branches to be up to date" causes constant rebase churn on
a busy repo THEN adopt a merge queue (GitHub) or merge train (GitLab)
INSTEAD of the up-to-date requirement. Merges are serialized and each
one is tested against the anticipated result before landing. NEVER
stack a merge queue on top of the up-to-date requirement. Not scored;
adopt when rebase churn becomes the bottleneck.

## CODEOWNERS
> Why: A stale CODEOWNERS pages people who left, which teaches the team that review requests are noise to be ignored.

`.github/CODEOWNERS` maps paths to reviewers so the right people are
requested automatically:

```text
# .github/CODEOWNERS
/scripts/   @security-team
/docs/      @docs-team
*.sh        @shell-reviewers
```

IF solo-dev THEN skip CODEOWNERS. ELSE: keep it small and current. IF
an entry pages someone who left THEN remove it -- a stale CODEOWNERS
is worse than none.

## Merge strategies (pick exactly one per project, stay consistent)
> Why: Mixed merge strategies produce history nobody can read, and unreadable history is history nobody trusts.

| Method | History shape | Use when |
|---|---|---|
| **Squash merge** | Linear, one commit per PR | Tidiest history; best default for feature-branch workflows. The PR title becomes the commit message -- write it conventionally, and lint the PR title in CI. |
| **Rebase merge** | Linear, per-commit replayed | Faithful history wanted; requires every commit clean on its own. Never rebase shared branches; use `--force-with-lease` on private ones. |
| **Merge commit** (`--no-ff`) | Non-linear, preserves topology | Branch topology carries information (release branches; GitFlow feature merges per Driessen). |

Enforcement: enable exactly one of `allow_merge_commit` /
`allow_squash_merge` / `allow_rebase_merge` in repo settings (verify
with `gh api repos/{owner}/{repo} --jq`). IF more than one is enabled
THEN FAIL -- inconsistency is what produces noisy history.

## Review discipline
> Why: Giant PRs get skimmed, not reviewed, so every unreviewed line is a bug the team agreed to ship sight unseen.

- Comment on code, not the author. Suggest concrete changes.
  Distinguish blocking issues from nits.
- IF a PR exceeds ~400 changed lines THEN split it: small PRs get
  reviewed, giant PRs get skimmed.
- Every PR description MUST answer three things: what changed, why,
  and how it was tested. See `assets/pull-request-template.md`.
