---
name: git-workflow
description: Guides selection and application of international standard git workflows: GitFlow, GitHub Flow, GitLab Flow, and trunk-based development, plus Conventional Commits, PR/review practices, merge strategies, branch protection, and release automation. Ships with a commit-message linter and a 100-point workflow-maturity scoring algorithm. Use when choosing a branching model for a project, setting up branch protection or PR templates, writing commit messages, designing a release process, auditing a repo's git hygiene, or when the user mentions git workflow, branching strategy, release flow, or conventional commits.
---

<!--
  git-workflow -- SKILL.md

  Purpose: entry point for the git-workflow skill. Picks the right branching
  model for the project at hand, applies the supporting practices
  (commits, PRs, releases), and can score a repo's workflow maturity
  0-100. Model details live in references/; the full scoring algorithm
  in references/05-maturity-scoring.md. This file stays lean and
  workflow-oriented. The skill is standalone: it defines every concept
  it scores (including the SemVer bump mapping) inline.
-->

# git-workflow

Git workflows are team coordination protocols, not personal habits.
This skill picks the right protocol for the project, applies it end to
end -- branching model, commit discipline, review loop, release -- and
scores how mature the result is.

## Pick the model first

Ask: how many people, and how are releases shipped?

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

The full decision tree (five inputs, evaluated in order) and per-model
parameters: `references/01-branching-models.md`.

## Core practices (apply regardless of model)

1. **Conventional Commits.** `<type>[scope][!]: <description>` --
   types `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`,
   `build`, `ci`, `chore`, `revert` (the spec defines only `feat` and
   `fix`; the rest come from the Angular convention via commitlint).
   Lowercase type, lowercase-start description, no trailing period,
   ~50-72 chars. The types make version numbers computable: `feat` ->
   minor bump, `fix` -> patch, breaking change -> major. Spec-mandated
   vs skill-strict rules: `references/02-conventional-commits.md`.
2. **Never commit on a dirty main.** Sync (`pull --rebase`) before
   starting work; push right after the commit lands.
3. **Review loop for teams.** Every change goes through a pull request;
   main is protected (no direct pushes, CI must pass, force pushes
   blocked). Merge strategy per project: squash for tidy history,
   rebase for faithful history, merge commits only when the branch
   topology matters. Details: `references/03-pr-review.md`.
4. **Release deliberately.** Tag with annotated tags (`v1.2.3`), write
   release notes from the commit history, publish through GitHub
   Releases, automate the version from commit types. Details:
   `references/04-releasing.md`.

## Workflow

1. **Select the model** using the decision tree. State the choice and
   why.
2. **Set up the repo:** branch protection rules (or Rulesets), PR
   template (`assets/pull-request-template.md`), commit linting
   (`scripts/commit-lint.sh` as a commit-msg hook or CI step; PR-title
   linting for squash-merge repos).
3. **Work the loop:** branch -> commit (linted) -> PR -> review -> merge
   (per chosen strategy) -> release (tagged).
4. **Verify:** `git log --oneline -10` shows clean conventional history;
   `git tag` matches releases.
5. **Score:** run the maturity algorithm in
   `references/05-maturity-scoring.md`. A fully disciplined repo scores
   exactly 100.

## Maturity scoring (summary)

Six weighted categories, every item mapped to a checkable probe or an
explicit human attestation. Full algorithm, exact commands, edge cases,
and pseudocode: `references/05-maturity-scoring.md`.

| Category | Points |
|---|---|
| 1. Branching model | 14 |
| 2. Commit discipline | 24 |
| 3. Review loop | 24 |
| 4. Merge discipline | 10 |
| 5. Release discipline | 20 |
| 6. Automation | 8 |
| **Total** | **100** |

Bands: 90-100 Exemplary, 70-89 Disciplined, 40-69 Developing, 0-39
Ad-hoc. Inapplicable items (solo-dev, no releases yet) are excluded
and the score renormalizes over what applies.

## Reference map

| File | Covers |
|---|---|
| `references/01-branching-models.md` | GitFlow, GitHub Flow, GitLab Flow, trunk-based: rules, trade-offs, decision tree |
| `references/02-conventional-commits.md` | Spec v1.0.0 essentials, spec-mandated vs skill-strict rules, SemVer mapping, loop hygiene |
| `references/03-pr-review.md` | Review loop, branch protection/Rulesets, merge queues, CODEOWNERS, merge strategies |
| `references/04-releasing.md` | Tagging, GitHub Releases, changelog generation, computable pipeline, hotfixes |
| `references/05-maturity-scoring.md` | The complete 0-100 scoring algorithm: probes, edge cases, pseudocode |

Read a reference only when its phase is active.

## Scripts and assets

- `scripts/commit-lint.sh` -- validates a commit message against
  Conventional Commits (spec v1.0.0 + the skill's house rules).
  Usage: `commit-lint.sh <file>` or pipe a message on stdin. Exit 0 on
  valid, 1 with a reason on stderr otherwise. POSIX sh, ASCII only.
- `assets/pull-request-template.md` -- PR template (what/why/testing).

## Guardrails

- Never rewrite public history (`push --force` on shared branches).
  Rebase is for private branches only; force pushes are blocked by
  branch protection (scored, not just advised).
- Never pick GitFlow by default. Justify it with parallel maintained
  versions or do not use it.
- A commit message is a contract with future readers: vague subjects
  (`fix bug`, `update`) are rejected by the linter for a reason.
- Do not invent workflow names. The four models above are the
  vocabulary; everything else is a variation, named as such.
