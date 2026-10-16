<!--
  05-maturity-scoring-rubric.md -- Reference for git-workflow.

  Covers: the 0-100 workflow-maturity scoring rubric: band legend, model
  selection (Step 0), and the six weighted categories with every item
  mapped to a checkable probe or an explicit human attestation (Step 1).
  Companion: 06-maturity-scoring-interpretation.md (Steps 2-4: N/A
  renormalization, edge cases, pseudocode, human-judged caveats).
  Read when auditing a repo or verifying an engagement.
-->

# Workflow maturity scoring (0-100)

## Contents

- [Band legend](#band-legend)
- [Step 0 - Select the model](#step-0---select-the-model)
- [Step 1 - Score the six categories](#step-1---score-the-six-categories)
  - [Category 1 - Branching model (14 pts)](#category-1---branching-model-14-pts)
  - [Category 2 - Commit discipline (24 pts)](#category-2---commit-discipline-24-pts)
  - [Category 3 - Review loop (24 pts)](#category-3---review-loop-24-pts)
  - [Category 4 - Merge discipline (10 pts)](#category-4---merge-discipline-10-pts)
  - [Category 5 - Release discipline (20 pts)](#category-5---release-discipline-20-pts)
  - [Category 6 - Automation (8 pts)](#category-6---automation-8-pts)

Scoring procedure:

1. Run Step 0, then score every item in Step 1.
2. Continue with `06-maturity-scoring-interpretation.md` (Steps 2-4:
   renormalize N/A items, apply edge cases, combine per the
   pseudocode) before reporting.

Every practice below maps to one checkable item: a machine probe
(exact command given) or an explicit human attestation (marked HUMAN).
Items that cannot be automated are labeled as such -- nothing is
silently omitted. A fully disciplined repo scores exactly 100.

## Band legend
> Why: Bands exist so a score becomes a conversation about what to fix next instead of a number to defend.

| Score | Band | Meaning |
|---|---|---|
| 90-100 | Exemplary | Fully disciplined, automated, auditable. |
| 70-89 | Disciplined | Workflow enforced end to end; minor gaps. |
| 40-69 | Developing | Some practices adopted; enforcement gaps. |
| 0-39 | Ad-hoc | No enforced workflow; history not machine-readable. |

Bands are tunable. The 100-point arithmetic is the stable part.

## Step 0 - Select the model
> Why: Scoring against the wrong model punishes a healthy repo for not being a different repo.

Run the decision tree in `references/01-branching-models.md` (five
inputs: `parallel_versions`, `staged_envs`, `team_size`,
`continuous_deployment`, `ci_maturity`). Every item below is scored
against the chosen model's parameters (branch lifetimes, merge method,
integration branches). IF no model was selected THEN STOP -- the
rubric has no baseline.

## Step 1 - Score the six categories

### Category 1 - Branching model (14 pts)

| # | Item | Pts | Evidence |
|---|---|---|---|
| 1.1 | Model explicitly chosen and documented: one of the four named models (GitFlow, GitHub Flow, GitLab Flow, trunk-based) plus why, in README/CONTRIBUTING/docs. No invented workflow names. | 4 | HUMAN (read the docs; confirm the model name and rationale exist) |
| 1.2 | Branch naming convention defined and followed. | 0/2/4 | AUTO: `git branch -a --format='%(refname:short)'` -> >=90% of work branches match the documented pattern = 4; 60-89% = 2; else 0 |
| 1.3 | Work-branch lifetimes within the model's bound (GitHub Flow <=1 day, trunk-based <=2 days, GitLab Flow days, GitFlow days-weeks). | 0/2/4 | AUTO: `git for-each-ref --sort=-committerdate --format='%(committerdate:short) %(refname:short)' refs/heads/` -> oldest open work branch within bound = 4; within 2x bound = 2; else 0 |
| 1.4 | Branch inventory matches the documented model: the model's integration branches exist (`develop`, `staging`/`production`, or trunk-only), and there are no unexpected long-lived branches. | 2 | AUTO: `git branch -a` compared against the model's branch set |

### Category 2 - Commit discipline (24 pts)

The linter is `scripts/commit-lint.sh` (exit 0 = conventional).
Spec-mandated vs skill-strict rules are defined in
`references/02-conventional-commits.md`.

| # | Item | Pts | Evidence |
|---|---|---|---|
| 2.1 | Share of the last 100 integration-branch commits passing `commit-lint.sh`. | pct x 10, rounded | AUTO: `for h in $(git log -100 --format='%H' main); do git log -1 --format=%B "$h" \| sh scripts/commit-lint.sh >/dev/null 2>&1 && pass=$((pass+1)); done` |
| 2.2 | Linting enforced, not just documented: a `commit-msg` hook exists, or a CI step lints commits. For squash-merge repos the enforcement point MUST be the PR title / squash message (e.g. a CI check on the PR title), because branch commits never reach history. | 4 | AUTO: `ls .git/hooks/commit-msg` or `grep -ri 'commit-lint\|commitlint\|semantic-pr\|semantic-pull-request' .github/workflows/ .husky/ 2>/dev/null` |
| 2.3 | No vague subjects in the last 100 commits (`fix bug`, `update`, `wip`, single-word subjects). | 4 | AUTO: `git log -100 --format=%s main \| grep -ciE '^(fix bug\|update\|wip\|tmp\|test)$'` = 0 |
| 2.4 | Breaking changes are marked with `!` or a `BREAKING CHANGE:` footer; no silent breaking changes in the window. | 4 | HUMAN (attestation; supporting heuristic: `git log --format=%B -100 \| grep -c 'BREAKING CHANGE'` cross-checked against release notes) |
| 2.5 | Sync discipline: contributors sync the integration branch before starting work (`git pull --rebase` or equivalent) and push promptly after landing; work never starts on a dirty main. | 2 | HUMAN (attestation; evidence: contributors confirm the habit, no stale-branch PRs) |

### Category 3 - Review loop (24 pts)

| # | Item | Pts | Evidence |
|---|---|---|---|
| 3.1 | Pull request required before merging to the integration branch (no direct pushes). | 4 | AUTO (GitHub): `gh api repos/{owner}/{repo}/branches/main/protection --jq .required_pull_request_reviews` is non-null. GitLab: branch is protected and "Allowed to merge" excludes direct push. |
| 3.2 | Required status checks must pass, and branches must be up to date before merging. | 4 | AUTO (GitHub): `.../protection --jq '{checks: .required_status_checks}'` shows `strict: true` and at least one context. GitLab: "Pipelines must succeed" + "merge request must be up to date" equivalent. |
| 3.3 | At least one approving review required (team repos). N/A for solo-dev: exclude and renormalize. | 4 | AUTO: `required_pull_request_reviews.required_approving_review_count >= 1`. GitLab: MR approval rules. |
| 3.4 | Stale review approvals dismissed when new commits land. | 2 | AUTO: `required_pull_request_reviews.dismiss_stale_reviews == true`. |
| 3.5 | Force pushes blocked on shared branches (the "never rewrite public history" guardrail, enforced mechanically). | 2 | AUTO (GitHub): `.../protection --jq .allow_force_pushes` == false. GitLab: protected branch, "Allowed to force push" off. |
| 3.6 | CODEOWNERS present and current (no reviewers who left). N/A for solo-dev: exclude and renormalize. | 2 | HUMAN (read `.github/CODEOWNERS`; confirm entries map to active contributors) |
| 3.7 | PR template present answering what / why / how-tested. | 2 | AUTO: `.github/pull-request-template.md` or `.github/PULL_REQUEST_TEMPLATE/` exists |
| 3.8 | PR size discipline: share of the last 20 PRs at or under ~400 changed lines. | 0/2/4 | AUTO (GitHub): `gh pr list --limit 20 --json additions,deletions` -> >=80% = 4; 50-79% = 2; else 0. GitLab: MR diff stats via the merge-request changes API. |

### Category 4 - Merge discipline (10 pts)

| # | Item | Pts | Evidence |
|---|---|---|---|
| 4.1 | Exactly one merge strategy chosen and documented (squash, rebase, or merge commit) with its rationale. | 4 | HUMAN (read the docs/CONTRIBUTING) |
| 4.2 | Strategy enforced in repo settings: exactly one merge method enabled. | 3 | AUTO (GitHub): `gh api repos/{owner}/{repo} --jq '{m: .allow_merge_commit, s: .allow_squash_merge, r: .allow_rebase_merge}'` -> exactly one true. GitLab: project "Merge method" setting. |
| 4.3 | Work branches deleted after merge; no stale branches older than 30 days. | 3 | AUTO: `git branch --merged main` shows no work branches left, and `git for-each-ref --format='%(committerdate:short) %(refname:short)' refs/heads/` shows nothing older than 30 days except integration branches |

### Category 5 - Release discipline (20 pts)

| # | Item | Pts | Evidence |
|---|---|---|---|
| 5.1 | Releases use annotated tags only. | 4 | AUTO: `for t in $(git tag); do git cat-file -t "$t"; done \| sort \| uniq -c` -> every line is `tag` |
| 5.2 | Tags follow SemVer with `v` prefix: `vMAJOR.MINOR.PATCH`, no leading zeros, optional prerelease/build. | 0/2/4 | AUTO: `git tag \| grep -cE '^v?(0\|[1-9][0-9]*)\.(0\|[1-9][0-9]*)\.(0\|[1-9][0-9]*)(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$'` -> >=90% of tags = 4; 60-89% = 2; else 0 |
| 5.3 | Release notes published for every release (GitHub Release notes or a changelog entry per version). | 4 | AUTO (GitHub): `gh release list` count matches release-tag count. Either host: `CHANGELOG.md` has one entry per released version |
| 5.4 | Changelog automated from conventional commits (release-please, semantic-release, git-cliff, conventional-changelog, or equivalent configured). | 4 | AUTO: config present (`.release-please-manifest.json`, `release-please-config.json`, `.releaserc*`, `cliff.toml`, or a workflow step generating notes) |
| 5.5 | Tags immutable: release tags are never moved, deleted, or recreated. | 4 | HUMAN (attestation; supporting: tag-protection rules where the host offers them) |

### Category 6 - Automation (8 pts)

| # | Item | Pts | Evidence |
|---|---|---|---|
| 6.1 | CI runs on every PR and every push to the integration branch. | 3 | AUTO: workflow triggers include `pull_request` and `push` on the integration branch; recent runs exist (`gh run list`) |
| 6.2 | The version number is derived from commit types (`fix`->PATCH, `feat`->MINOR, breaking->MAJOR); no human picks the number. | 3 | AUTO: release automation from 5.4 configured for versioning (release-please / semantic-release), or bot-authored version-bump PRs |
| 6.3 | Releases are published by the pipeline (tag-triggered workflow or release automation), not by hand. | 2 | AUTO: workflow triggered on `release`/`tags`, or release-please/semantic-release publish step |

**Total: 14 + 24 + 24 + 10 + 20 + 8 = 100.**

After scoring each item, continue with `06-maturity-scoring-interpretation.md` (Step 2: renormalize N/A items; Step 3: edge cases; Step 4: pseudocode).
