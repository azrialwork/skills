<!--
  CHANGELOG.md -- Changelog for the skills collection.

  Purpose: human-curated history of skill additions, changes, and fixes,
  in Keep a Changelog format. Update on every skill change.
-->

# Changelog

All notable changes to this skills collection are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- `research`: turns vague questions into source-graded, date-stamped
  deliverables with explicit confidence levels, for any topic via a declared
  topic adapter. Source hierarchy with official docs as source of truth,
  per-claim "verified as of" stamps, two-source triangulation, honest
  unknowns; ships `scripts/cite-check.sh` and a standalone 0-100
  research-quality scoring algorithm.
- `create-skill`: guides building professional Agent Skills (SKILL.md).
  Frontmatter rules, description formula, progressive disclosure,
  invocation/permission models, security review, `scripts/validate.py`
  validator with `--score` mode, and a standalone 0-100 skill-quality
  scoring algorithm.
- `oss-standards`: applies international open-source industry standards
  (installer script, repo structure, README, SemVer, SPDX, SLSA/Sigstore,
  Scorecard, SECURITY.md, hardened CI/CD, docs). `scripts/repo-audit.sh`
  checklist auditor (16 NOW checks) and a standalone 0-100 compliance
  scoring algorithm.
- `no-slop`: keeps AI-generated content free of AI slop via a
  generate-then-audit workflow. Tiered rules (Hard Gate, Purpose-Gate,
  Quality Locks), liveliness bar, density-aware `scripts/slop-scan.sh`
  heuristic scanner, and a standalone 0-100 text-quality scoring
  algorithm.
- `git-workflow`: international standard git workflows (GitFlow, GitHub
  Flow, GitLab Flow, trunk-based development), Conventional Commits,
  PR/review practices, merge strategies, release automation.
  `scripts/commit-lint.sh` and a standalone 0-100 maturity scoring
  algorithm with a model-selection decision tree.
- Repo hygiene: CI validation workflow (dogfoods all four skills),
  OpenSSF Scorecard workflow, Dependabot for GitHub Actions,
  SECURITY.md, CODEOWNERS, issue/PR templates.

### Changed
- All four skills rewritten against their official documentation as
  source of truth (verified 2026-10-13): SPDX spec 3.0.1, CycloneDX
  1.6/1.7, SLSA v1.2, REUSE 3.3, Scorecard v5.5.0, Conventional Commits
  1.0.0, Agent Skills spec.
- Each skill is now standalone: no cross-skill references; every concept
  a skill needs is defined inline.
