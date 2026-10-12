---
name: git-workflow
description: Guides selection and application of international standard git workflows: GitFlow, GitHub Flow, GitLab Flow, and trunk-based development, plus Conventional Commits, PR/review practices, merge strategies, branch protection, and release automation. Use when choosing a branching model for a project, setting up branch protection or PR templates, writing commit messages, designing a release process, or when the user mentions git workflow, branching strategy, release flow, or conventional commits. Ships with a commit-message linter.
---

<!--
  git-workflow -- SKILL.md

  Purpose: entry point for the git-workflow skill. Picks the right branching
  model for the project at hand and applies the supporting practices
  (commits, PRs, releases). Model details live in references/.
-->

# git-workflow

Git workflows are team coordination protocols, not personal habits.
This skill picks the right protocol for the project and applies it
end to end: branching model, commit discipline, review loop, release.

## Pick the model first

Ask two questions: how many people, and how are releases shipped?

| Situation | Model | Shape |
|---|---|---|
| Solo dev or 2-3 people, continuous delivery | Trunk-based (or direct-to-main) | Short-lived branches (hours, max 1-2 days), merge to main constantly |
| Small team, PR-based review | GitHub Flow | `main` + feature branches + pull requests; deploy from main |
| Staged environments (staging -> production) | GitLab Flow | Environment branches (`main` -> `staging` -> `production`) or release branches |
| Versioned software, multiple releases maintained in parallel | GitFlow | `main`, `develop`, `feature/*`, `release/*`, `hotfix/*` |

Default for a new project without special needs: GitHub Flow. It is the
simplest model that still gives review and CI a place to live. Do not
reach for GitFlow unless parallel maintained versions are a real
requirement -- its own creator walked the recommendation back in 2020.

Model details and trade-offs: `references/01-branching-models.md`.

## Core practices (apply regardless of model)

1. **Conventional Commits.** `<type>: <subject>` -- types `feat`, `fix`,
   `docs`, `refactor`, `test`, `chore`, `perf`, `ci`, `revert`. Imperative
   subject, ~50 chars. The types make version numbers computable:
   `feat` -> minor bump, `fix` -> patch, breaking change -> major.
   Details: `references/02-conventional-commits.md`.
2. **Never commit on a dirty main.** Sync (`pull --rebase`) before
   starting work; push right after the commit lands.
3. **Review loop for teams.** Every change goes through a pull request;
   main is protected (no direct pushes, CI must pass). Merge strategy
   per project: squash for tidy history, rebase for faithful history,
   merge commits only when the branch topology matters.
   Details: `references/03-pr-review.md`.
4. **Release deliberately.** Tag with annotated tags (`v1.2.3`), write
   release notes from the commit history, publish through GitHub
   Releases. Details: `references/04-releasing.md`.

## Workflow

1. **Select the model** using the table above. State the choice and why.
2. **Set up the repo:** branch protection rules, PR template
   (`assets/pull-request-template.md`), commit linting
   (`scripts/commit-lint.sh` as a commit-msg hook or CI step).
3. **Work the loop:** branch -> commit (linted) -> PR -> review -> merge
   (per chosen strategy) -> release (tagged).
4. **Verify:** `git log --oneline -10` shows clean conventional history;
   `git tag` matches releases.

## Reference map

| File | Covers |
|---|---|
| `references/01-branching-models.md` | GitFlow, GitHub Flow, GitLab Flow, trunk-based: rules, trade-offs, decision guide |
| `references/02-conventional-commits.md` | Spec essentials, types, breaking changes, examples |
| `references/03-pr-review.md` | Review loop, CODEOWNERS, branch protection, merge strategies |
| `references/04-releasing.md` | Tagging, GitHub Releases, changelog generation, automation |

Read a reference only when its phase is active.

## Scripts and assets

- `scripts/commit-lint.sh` -- validates a commit message against
  Conventional Commits. Usage: `commit-lint.sh <file>` or pipe a message
  on stdin. Exit nonzero with a reason on failure.
- `assets/pull-request-template.md` -- PR template (what/why/testing).

## Collaborating with other skills

- **oss-standards:** the release process here feeds its CHANGELOG.md,
  SemVer, and CI/CD standards. Apply both when professionalizing a repo.
- **no-slop:** commit subjects and PR descriptions are user-facing
  prose. Run them through no-slop AFTER so `fix: stuff` never ships.
- **create-skill:** if a team's git ritual stabilizes into something
  reusable, package it with create-skill.

## Guardrails

- Never rewrite public history (`push --force` on shared branches).
  Rebase is for private branches only.
- Never pick GitFlow by default. Justify it with parallel maintained
  versions or do not use it.
- A commit message is a contract with future readers: vague subjects
  (`fix bug`, `update`) are rejected by the linter for a reason.
- Do not invent workflow names. The four models above are the
  vocabulary; everything else is a variation, named as such.
