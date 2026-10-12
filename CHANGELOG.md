<!--
  CHANGELOG.md -- Changelog for the skills collection.

  Purpose: human-curated history of skill additions, changes, and fixes,
  in Keep a Changelog format. Update on every skill change.
-->

# Changelog

All notable changes to this skills collection are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [2026-10-12] -- no-slop upgraded, cross-skill collaboration

### Added
- `no-slop`: tiered rule system (Hard Gate H-01..H-04, Purpose-Gate
  P-01..P-05, Quality Locks Q-01..Q-05), before/after examples per marker,
  DURING/AFTER usage modes, four-block Delivery Gate, liveliness bar with
  topic-swap test. Scanner gains em-dash hard-fail (H-02) and extended
  phrase vocabulary. Concepts adopted from miqdadbadjuber/anti-slop
  (v3.2.20, MIT); content written originally.
- Cross-skill collaboration sections in all three SKILL.md files.
- `CHANGELOG.md`, `SECURITY.md`, and CI validation workflow for this repo.

## [2026-10-12] -- no-slop added

### Added
- `no-slop`: keeps AI-generated content free of AI slop via a
  generate-then-audit workflow. Marker catalogs (lexical, structural,
  substance), anti-slop writing rules, self-audit checklist, and
  `scripts/slop-scan.sh` heuristic scanner with phrase list.

## [2026-10-12] -- oss-standards added

### Added
- `oss-standards`: applies international open-source industry standards
  (professional install.sh, repo structure, README anatomy, SemVer,
  SPDX, SLSA/Sigstore, SECURITY.md, hardened CI/CD, docs). 14 references,
  `scripts/repo-audit.sh` checklist auditor, SECURITY template, and
  installer skeleton.

## [2026-10-12] -- create-skill added

### Added
- `create-skill`: guides building professional Agent Skills. Full research
  baked into 10 references, `scripts/validate.py` validator, and
  `assets/SKILL-template.md`. End-to-end audited on OpenCode 1.19.0.
