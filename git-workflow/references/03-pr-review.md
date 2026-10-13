<!--
  03-pr-review.md -- Reference for git-workflow.

  The pull-request review loop: branch protection (classic rules and
  the newer Rulesets), CODEOWNERS, merge queues, merge strategies, and
  review discipline. Current as of 2026-10-13. Read when setting up
  team collaboration on a repo.
-->

# PR and review workflow

## The loop

1. Branch from the integration branch (`main` in GitHub Flow).
2. Push early; open the pull request as a draft if it is not ready.
3. CI runs on the PR. Review happens on the PR. Discussion happens on
   the PR. The PR is the unit of collaboration.
4. Merge with the project's chosen strategy, then delete the branch.

## Branch protection (GitHub)

Two mechanisms exist; both are current. Classic branch protection
rules live under Settings -> Branches. **Rulesets** (Settings -> Rules)
are the newer, layered mechanism: named rule sets that can target
multiple branches and compose. Either satisfies the checklist below;
Rulesets are the better choice when one policy must cover many
branches.

Minimum useful checklist (verify with
`gh api repos/{owner}/{repo}/branches/main/protection`):

- Require a pull request before merging (no direct pushes).
- Require status checks to pass, and require branches to be up to date
  before merging (the check runs against the code that will land).
- Require at least one approving review for team repos.
- Dismiss stale PR approvals when new commits are pushed.
- Require review from Code Owners (when CODEOWNERS exists).
- Require conversation resolution before merging.
- Block force pushes and branch deletions on shared branches.
- Do not allow bypassing the above settings (no admin bypass unless a
  documented emergency escape hatch exists).

Optional: require linear history (forbids merge commits; only valid
with squash or rebase strategies).

Note: the protection API replaces the whole rule on write -- partial
payloads silently drop omitted settings.

## Merge queues (advanced)

When "require branches to be up to date" causes constant rebase churn
on a busy repo, a **merge queue** (GitHub) or **merge train** (GitLab)
is the better mechanism: merges are serialized and each one is tested
against the anticipated result before landing. It replaces the
up-to-date requirement rather than stacking on top of it. Not scored;
adopt when rebase churn becomes the bottleneck.

## CODEOWNERS

`.github/CODEOWNERS` maps paths to reviewers so the right people are
requested automatically:

```
# .github/CODEOWNERS
/scripts/   @security-team
/docs/      @docs-team
*.sh        @shell-reviewers
```

Keep it small and current. A stale CODEOWNERS that pages people who
left is worse than none. Solo-dev repos skip this.

## Merge strategies (pick exactly one per project, stay consistent)

| Method | History shape | Use when |
|---|---|---|
| **Squash merge** | Linear, one commit per PR | Tidiest history; best default for feature-branch workflows. The PR title becomes the commit message -- write it conventionally, and lint the PR title in CI. |
| **Rebase merge** | Linear, per-commit replayed | Faithful history wanted; requires every commit clean on its own. Never rebase shared branches; use `--force-with-lease` on private ones. |
| **Merge commit** (`--no-ff`) | Non-linear, preserves topology | Branch topology carries information (release branches; GitFlow feature merges per Driessen). |

Enforce the choice in repo settings: enable exactly one of
`allow_merge_commit` / `allow_squash_merge` / `allow_rebase_merge`
(`gh api repos/{owner}/{repo} --jq` to verify). Inconsistency is what
produces noisy history.

## Review discipline

- Review the diff, not the author. Comment on code, suggest concrete
  changes, distinguish blocking issues from nits.
- Small PRs get reviewed; giant PRs get skimmed. Keep PRs under ~400
  changed lines when possible.
- A PR description answers three things: what changed, why, and how
  it was tested. See `assets/pull-request-template.md`.
