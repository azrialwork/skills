<!--
  03-pr-review.md -- Reference for git-workflow.

  The pull-request review loop: branch protection, CODEOWNERS, review
  discipline, and merge strategies. Read when setting up team
  collaboration on a repo.
-->

# PR and review workflow

## The loop

1. Branch from the integration branch (`main` in GitHub Flow).
2. Push early; open the pull request as a draft if it is not ready.
3. CI runs on the PR. Review happens on the PR. Discussion happens on
   the PR. The PR is the unit of collaboration.
4. Merge with the project's chosen strategy, then delete the branch.

## Branch protection (the minimum useful setup)

- Require pull request before merging to `main` (no direct pushes).
- Require status checks to pass (CI green).
- Require at least one approving review for team repos.
- Dismiss stale reviews when new commits land.

## CODEOWNERS

A `CODEOWNERS` file maps paths to reviewers so the right people are
requested automatically:

```
# .github/CODEOWNERS
/scripts/   @security-team
/docs/      @docs-team
*.sh        @shell-reviewers
```

Keep it small and current. A stale CODEOWNERS that pages people who
left is worse than none.

## Merge strategies (pick one per project, stay consistent)

- **Squash merge:** one commit per PR on main. Tidest history; the PR
  title becomes the commit message (so write it conventionally).
  Best default for feature-branch workflows.
- **Rebase merge:** replays each commit onto main. Faithful history,
  requires every commit to be clean on its own.
- **Merge commit:** preserves branch topology. Useful when the fact
  that work happened on a branch carries information (release branches).

## Review discipline

- Review the diff, not the author. Comment on code, suggest concrete
  changes, distinguish blocking issues from nits.
- Small PRs get reviewed; giant PRs get skimmed. Keep PRs under ~400
  changed lines when possible.
- A PR description answers three things: what changed, why, and how
  it was tested. See `assets/pull-request-template.md`.
