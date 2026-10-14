---
name: git-workflow
description: Guides selection and application of international standard git workflows: GitFlow, GitHub Flow, GitLab Flow, and trunk-based development, plus Conventional Commits, PR/review practices, merge strategies, branch protection, and release automation. Ships with the commit-message linter `scripts/commit-lint.sh` and a 100-point workflow-maturity scoring algorithm in `references/`; not for repo-wide standards audits or installer-script checklists. Use when choosing a branching model for a project, setting up branch protection or PR templates (`.github/pull-request-template.md`), writing commit messages, designing a release process, auditing a repo's git hygiene, or when the user mentions git workflow, branching strategy, release flow, or conventional commits.
---

# git-workflow

Git workflows are team coordination protocols, not personal habits. This skill picks the right protocol for the project, applies it end to end -- branching model, commit discipline, review loop, release -- and scores how mature the result is on a 0-100 rubric.

## Trigger

USE WHEN:
- Choosing a branching model for a project.
- Setting up branch protection or PR templates (`.github/pull-request-template.md`).
- Writing commit messages.
- Designing a release process.
- Auditing a repo's git hygiene.
- The user mentions git workflow, branching strategy, release flow, or conventional commits.

DO NOT USE WHEN:
- The task is a repo-wide standards audit or an installer-script checklist (use oss-standards).

## Algorithm

INPUT: the project (team size, release shape, current repo state) and the task.

### Step 1 -- Select the branching model

Evaluate in order; the first matching row wins. IF no row matches THEN select GitHub Flow.

| IF the situation is | THEN select | Shape |
|---|---|---|
| Solo dev or 2-3 people, continuous delivery | Trunk-based (or direct-to-main) | Short-lived branches (hours, max 1-2 days), merge to main constantly |
| Small team, PR-based review | GitHub Flow | `main` + feature branches + pull requests; deploy from main |
| Staged environments (staging -> production) | GitLab Flow | Environment branches (`main` -> `staging` -> `production`) or release branches |
| Versioned software, multiple releases maintained in parallel | GitFlow | `main`, `develop`, `feature/*`, `release/*`, `hotfix/*` |

State the choice and why. IF the choice is GitFlow THEN you MUST justify it with parallel maintained versions; its own creator walked the recommendation back in 2020. (Full decision tree: `references/01-branching-models.md`.)

### Step 2 -- Apply core practices

1. **Conventional Commits.** Every message MUST match `<type>[scope][!]: <description>` with type in `feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert` (the spec defines only `feat` and `fix`; the rest come from the Angular convention via commitlint). Type lowercase, description starts lowercase, no trailing period, ~50-72 chars. SemVer mapping: `feat` -> minor bump, `fix` -> patch, breaking change (`!`) -> major. (Spec-mandated vs skill-strict rules: `references/02-conventional-commits.md`.)
2. **Main hygiene.** IF main is dirty THEN sync with `pull --rebase` BEFORE starting work. Push immediately after the commit lands.
3. **Review loop.** IF the project has more than one contributor THEN every change MUST go through a pull request; main is protected: no direct pushes, CI must pass, force pushes blocked. Merge strategy: IF tidy history is the goal THEN squash; ELSE IF faithful history is the goal THEN rebase; ELSE IF the branch topology matters THEN merge commits. (Details: `references/03-pr-review.md`.)
4. **Release.** Tag with annotated tags (`v1.2.3`), write release notes from the commit history, publish through GitHub Releases, automate the version from commit types. (Details: `references/04-releasing.md`.)

### Step 3 -- Set up the repo

1. Branch protection rules (or Rulesets).
2. PR template from `assets/pull-request-template.md`.
3. Commit linting: install `scripts/commit-lint.sh` as a commit-msg hook or CI step. IF the repo uses squash-merge THEN also lint PR titles.

### Step 4 -- Work the loop

Branch -> commit (linted) -> PR -> review -> merge (per chosen strategy) -> release (tagged).

### Step 5 -- Verify

1. `git log --oneline -10` shows clean conventional history. IF not THEN FAIL.
2. `git tag` matches the releases. IF not THEN FAIL.

### Step 6 -- Score maturity

Run the rubric in `references/05-maturity-scoring-rubric.md`, then interpret per `references/06-maturity-scoring-interpretation.md`. Six weighted categories, every item mapped to a checkable probe or an explicit human attestation:

| Category | Points |
|---|---|
| 1. Branching model | 14 |
| 2. Commit discipline | 24 |
| 3. Review loop | 24 |
| 4. Merge discipline | 10 |
| 5. Release discipline | 20 |
| 6. Automation | 8 |
| **Total** | **100** |

Bands: 90-100 Exemplary, 70-89 Disciplined, 40-69 Developing, 0-39 Ad-hoc. IF an item is inapplicable (solo-dev, no releases yet) THEN exclude it and renormalize the score over what applies. A fully disciplined repo scores exactly 100.

## Verify

- [ ] PASS: a branching model is stated with its reason, and GitFlow (if chosen) is justified by parallel maintained versions.
- [ ] PASS: `scripts/commit-lint.sh` rejects vague subjects (`fix bug`, `update`) and accepts valid conventional messages.
- [ ] PASS: `git log --oneline -10` shows only conventional-format subjects.
- [ ] PASS: main has no direct pushes; branch protection is active.
- [ ] PASS: maturity score computed; inapplicable items excluded and renormalized.

## Guardrails

- NEVER rewrite public history (`push --force` on shared branches). Rebase is for private branches only.
- NEVER pick GitFlow by default; justify it with parallel maintained versions or do not use it.
- NEVER commit a vague subject; the linter rejects them for a reason.
- NEVER invent workflow names. The four models above are the vocabulary; everything else is a named variation.

## Reference map

| File | Covers |
|---|---|
| `references/01-branching-models.md` | GitFlow, GitHub Flow, GitLab Flow, trunk-based: rules, trade-offs, decision tree |
| `references/02-conventional-commits.md` | Spec v1.0.0 essentials, spec-mandated vs skill-strict rules, SemVer mapping, loop hygiene |
| `references/03-pr-review.md` | Review loop, branch protection/Rulesets, merge queues, CODEOWNERS, merge strategies |
| `references/04-releasing.md` | Tagging, GitHub Releases, changelog generation, computable pipeline, hotfixes |
| `references/05-maturity-scoring-rubric.md` | The 0-100 rubric: band legend, model selection, six weighted categories with probes/attestations |
| `references/06-maturity-scoring-interpretation.md` | Score interpretation: N/A renormalization, encoded edge cases, pseudocode, human-judged caveats |

Read a reference only when its phase is active.

## Scripts and assets

- `scripts/commit-lint.sh` -- validates a commit message against Conventional Commits (spec v1.0.0 + the skill's house rules). Usage: `commit-lint.sh <file>` or pipe a message on stdin. Exit 0 on valid, 1 with a reason on stderr otherwise. POSIX sh, ASCII only.
- `assets/pull-request-template.md` -- PR template (what/why/testing).
