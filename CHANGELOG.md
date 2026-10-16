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
- Repo hygiene: CI validation workflow (dogfoods all five skills),
  OpenSSF Scorecard workflow, Dependabot for GitHub Actions,
  SECURITY.md, CODEOWNERS, issue/PR templates.

### Changed
- 2026-10-16 consistency refactor (branch
  `refactor/consistency-2026-10-16`): conflict matrix in
  `CONFLICTS.md` (20 items, all resolved with recorded decisions);
  all 117 em dash characters removed from `.md` files; all bare code
  fences tagged; TOCs added to 13 reference files over 100 lines
  (3 omitted where a TOC would breach the 150-line limit); scoring
  band labels unified to American English; CI validation now covers
  all five skills. Policy correction: skills use progressive
  disclosure with pointers to `references/`, `assets/`, and
  `scripts/` in the same skill; this supersedes the 2026-10-14
  "standalone, no pointers" wording below. Validation scores
  unchanged (4x100, no-slop 93).
- 2026-10-14 mechanical refactor (commits `d078cf4`, `a09081a`,
  `ca170bb`, `ec38b03`, `ed13d71`): all five `SKILL.md` rewritten to
  one skeleton (Trigger, Algorithm, Verify, Guardrails, Reference
  map, Scripts and assets); all `references/*.md` rewritten as
  numbered algorithms (INPUT, IF/THEN/ELSE, PASS/FAIL) with scoring
  pseudocode/formulas/weights/IDs kept verbatim; all reference files
  renamed to consistent `NN-descriptive-slug.md` (no letter suffixes)
  with all cross-links updated; distro-specific references removed
  (Termux, ubuntu/debian/alpine/fedora -> generic glibc-based /
  musl-based / minimal POSIX categories); 227 labeled `> Why:`
  one-liners added, one per rule-bearing section, stating the human
  cost of violation (additive-only, zero deletions). Validation
  scores unchanged (4x100, no-slop 93).
  content now lives inline with no external pointers (research pins
  remain in `azrial/research/anti-slop-skills/`). Added accessibility
  floor + mobile rules to 06c (the last unmerged advantage from the
  research: antislop-human/layoutmobile).
- `no-slop`: full merge with six researched anti-slop skills
  (upstream pins recorded in the research notes). New
  `references/14-code-comment-hygiene.md` (AI-slop comment cleanup,
  comments-only scope guardrail) and
  `references/06-ui-slop-patterns.md` (visual slop: color, layout,
  typography, decoration, motion, app screens, UI copy, checklist).
  Markers enriched: Not-X-but-Y family, staged run-ups, forced triads,
  passive voice, -ing riders, sales language, knowledge-limit
  disclaimers, AI-tool fingerprints, false agency, portability test
  (from humanizer, avoid-ai-writing, no-ai-slop, stop-slop). Tiered
  vocabulary (1A/1B shots, Tier-2 paragraph clusters, Tier-3 density
  groups) in `assets/slop-phrases.txt`; `scripts/slop-scan.sh` gains
  `# @cluster:<group>` mode and generic density groups. SKILL.md gains
  module loading, minimum-effective-edit, voice-sample override, and
  show-its-work principles. Tier-2 words (nuanced, multifaceted,
  elevate, empower, streamline) moved from shots to cluster mode to
  cut false positives.
- All four skills rewritten against their official documentation as
  source of truth (verified 2026-10-13): SPDX spec 3.0.1, CycloneDX
  1.6/1.7, SLSA v1.2, REUSE 3.3, Scorecard v5.5.0, Conventional Commits
  1.0.0, Agent Skills spec.
- Each skill is now standalone: no cross-skill references; every concept
  a skill needs is defined inline.
