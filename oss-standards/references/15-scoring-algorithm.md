<!--
  15-scoring-algorithm.md -- Reference for oss-standards.

  Covers: the complete, standalone 0-100 open-source compliance scoring
  algorithm -- band legend, inputs, procedure (including N/A renormalization
  and the NOW-gate), and all 33 criteria tables with weights and probes.
  Worked example, pseudocode, anti-patterns, and pinned standard versions
  live in 16-scoring-appendix.md.

  This file is self-contained: it does not depend on any other skill
  or any other file in this skill to be applied.
-->
# Compliance scoring algorithm (0-100)

## Band legend

| Score | Band | Meaning |
|---|---|---|
| 90-100 | Teladan (exemplary) | Professional on every axis; publish as an example |
| 70-89 | Matang (disciplined) | Production-ready; remaining items are hardening |
| 40-69 | Berkembang (developing) | Usable but visibly incomplete |
| 0-39 | Kritis (critical) | Foundational trust missing; do not promote yet |

Bands are tunable: adjust the legend to the repo. The NOW-gate (procedure step 4) is NOT tunable -- it always applies.

## Inputs

INPUT: the repository under audit.

1. Repository directory (or `owner/repo`) + default branch.
2. Tool outputs: `shellcheck`, `shfmt -d`, `sh -n`, `bats`, `reuse lint`, `git`/`gh` data (tags, releases + asset lists, workflows, advisories), one OpenSSF Scorecard v5.5.0 run.
3. Human-rubric answers for items marked `[rubric]`: score 0-k per the stated scale; no free-form partial credit. IF an item has no fixed scale THEN it cannot be a `[rubric]` item -- FAIL the rubric design.

## Procedure

1. **Classify.** Tag each criterion NOW / SOON / LATER per the tables.
   LATER criteria marked N/A for the repo shape (no outside
   contributors, README < 200 lines, no corporate adoption, no
   bundled deps) are **excluded** from numerator and denominator.
2. **Probe.** Run each applicable criterion's probe: `[auto]` = exact
   command (pass = full points, fail = 0, unless a graded scale is
   given); `[rubric]` = human scores 0-k per the stated scale.
3. **Aggregate.**
   `score = 100 x sum(earned) / sum(applicable max points)`
4. **NOW-gate (ordering principle).** If any applicable NOW criterion
   scores 0, `final = min(score, 59)`. A signed SBOM on a repo with no
   LICENSE is theater, not professionalism.
5. **Report.** Score (1 decimal), band, per-criterion evidence
   (probe command + output), and the remediation pointer for every
   item below maximum.

## Criteria

### 1. Installer script (20 pts)

| ID | Item | Pts | Phase | Probe |
|---|---|---|---|---|
| I1 | Shebang `#!/bin/sh` + exact `set -eu` on its own line (or `#!/usr/bin/env bash`/`#!/bin/bash` + `set -euo pipefail`, dialect self-consistent) | 3 | NOW | `[auto]` `head -n1 install.sh`; `grep -Eq '^set -eu$' install.sh` |
| I2 | No bashisms under `#!/bin/sh`: `[[ ]]`, `function`, `source`, arrays, `pipefail` | 2 | NOW | `[auto]` `! grep -Eq '\[\|\<function\>\|\<source\>\|pipefail' install.sh` |
| I3 | Every curl call uses `--proto '=https' --tlsv1.2 -fsSL` | 3 | NOW | `[auto]` `grep -qF -- "--proto '=https'" install.sh && grep -qF -- '--tlsv1.2' install.sh` (skip if no curl) |
| I4 | SHA256SUMS verification present and fail-closed (missing/bad checksum -> nonzero exit). Scale: 4 = verified fail-closed; 2 = checksum present, failure path not traced; 0 = none | 4 | NOW | `[auto]` `grep -qi sha256 install.sh`; `[rubric]` trace the failure path |
| I5 | `tmpdir=$(mktemp -d)` + `trap 'rm -rf "$tmpdir"' EXIT INT TERM`; every `rm -rf` quoted | 2 | NOW | `[auto]` `grep -q 'mktemp -d' install.sh && grep -q "trap .* EXIT" install.sh && ! grep -Eq 'rm -rf [^"'"'"']*\$[A-Za-z_]' install.sh` |
| I6 | `--help` and `--version` flags; non-interactive mode (`--yes`, `NONINTERACTIVE=1`, or tty-detect) | 2 | SOON | `[auto]` `grep -q -- '--help' install.sh && grep -q -- '--version' install.sh` |
| I7 | Platform matrix via `case $(uname -sm)` (aarch64/arm64, x86_64; Android/musl note where relevant); loud failure on unsupported. Scale 0-2 | 2 | SOON | `[auto]` `grep -q 'uname' install.sh`; `[rubric]` matrix completeness |
| I8 | `shellcheck` exit 0 and `shfmt -d` zero-diff | 2 | SOON | `[auto]` `shellcheck install.sh`; `shfmt -d install.sh` |

### 2. Repository and README (15 pts)

| ID | Item | Pts | Phase | Probe |
|---|---|---|---|---|
| R1 | `README.md`, `LICENSE`, `.gitignore`, `CHANGELOG.md`, `SECURITY.md` exist (1 pt each) | 5 | NOW | `[auto]` `test -f` each |
| R2 | No binaries committed to git | 2 | NOW | `[auto]` `! git ls-files \| grep -Eq '\.(exe\|dll\|so\|dylib\|bin\|o\|a)$'` |
| R3 | README mandatory sections present and ordered: pitch, badges, installation, quickstart, usage, troubleshooting, license. Scale 0-3 (3 = all, ordered; 2 = all present; 1 = partial; 0 = missing) | 3 | SOON | `[rubric]` (heading scan assisted) |
| R4 | `.github/workflows/` exists; `dependabot.yml` declares `github-actions` ecosystem | 2 | NOW | `[auto]` `test -d`; `grep -q 'github-actions' .github/dependabot.yml` |
| R5 | `CODEOWNERS` (`* @owner` minimum) + issue/PR templates exist | 2 | SOON | `[auto]` `test -f` each |
| R6 | `.gitattributes`: `* text=auto`, scripts `eol=lf` | 1 | LATER | `[auto]` `grep -q 'text=auto' .gitattributes` |

### 3. Versioning and releases (15 pts)

| ID | Item | Pts | Phase | Probe |
|---|---|---|---|---|
| V1 | Git tags match SemVer 2.0.0 BNF `^v?MAJOR.MINOR.PATCH([-+].*)?$`, no leading zeros. Graded: % conforming x 3 | 3 | NOW | `[auto]` scan `git tag -l` |
| V2 | `CHANGELOG.md` follows Keep a Changelog 1.1.0: `## [Unreleased]`, version headings `## [x.y.z] - YYYY-MM-DD`, categories only from {Added, Changed, Deprecated, Removed, Fixed, Security}. Scale 0-3 | 3 | NOW | `[rubric]` (structure scan assisted) |
| V3 | Every `vX.Y.Z` tag has a matching `## [X.Y.Z]` changelog heading | 2 | SOON | `[auto]` loop tags vs `grep -q "## \[$v\]" CHANGELOG.md` |
| V4 | Conventional Commits 1.0.0 conformance: % of commits since last tag parsing `<type>[scope][!]: <desc>` (spec-mandated types: `feat`, `fix`; others per Angular/commitlint convention). Graded: % x 3 | 3 | SOON | `[auto]` `git log` parse |
| V5 | Release automation: changelog generated from commits; artifacts built only by CI; `SHA256SUMS` attached. Scale 0-2 | 2 | SOON | `[rubric]` + `[auto]` release asset scan |
| V6 | Release tags are annotated objects (`git cat-file -t` = `tag`); tags never moved | 2 | SOON | `[auto]` `git cat-file -t vX.Y.Z` |

Conventional Commits 1.0.0 essentials (inlined; source of truth:
conventionalcommits.org/en/v1.0.0): `<type>[optional scope][!]:
<description>`, blank line, optional body, blank line, optional
footers (`Token: value`, git-trailer style). `feat` -> MINOR,
`fix` -> PATCH, `!` or `BREAKING CHANGE:` footer -> MAJOR. Only
`feat`/`fix` have spec-defined meaning; `build/chore/ci/docs/style/
refactor/perf/test/revert` come from the Angular convention via
commitlint config-conventional and carry no implicit SemVer effect.

### 4. Licensing and compliance (10 pts)

| ID | Item | Pts | Phase | Probe |
|---|---|---|---|---|
| L1 | `LICENSE` full text at root; text matches an OSI-approved license. Scale: 4 = verbatim match to opensource.org text; 2 = present with formatting-only diffs; 0 = missing or unapproved | 4 | NOW | `[auto]` `test -f LICENSE`; `[rubric]` text compare |
| L2 | SPDX identifier valid (on the SPDX License List, currently 3.29.0) in README badges and/or package metadata; expression parses per SPDX ABNF (`+` > `WITH` > `AND` > `OR`) | 3 | NOW | `[auto]` extract `SPDX-License-Identifier:` / badge ID; look up in list JSON |
| L3 | REUSE 3.3: `reuse lint` clean (N/A -> excluded when per-file licensing does not matter yet) | 2 | LATER | `[auto]` `reuse lint` |
| L4 | Attribution file (`NOTICE` / `THIRD_PARTY`) listing bundled deps with licenses (N/A -> excluded when no bundled deps) | 1 | LATER | `[rubric]` |

### 5. Supply-chain security (15 pts)

| ID | Item | Pts | Phase | Probe |
|---|---|---|---|---|
| S1 | `SHA256SUMS` published with every release | 4 | SOON | `[auto]` `gh release view --json assets` / `[rubric]` |
| S2 | Checksums/artifacts signed: minisign (`.minisig`), GPG (`.asc`), or Sigstore bundle -- verify signed-by-*whom*, not just "signed" | 3 | SOON | `[auto]` asset scan; `minisign -V` / `cosign verify-blob` |
| S3 | SLSA provenance / GitHub Artifact Attestations on releases (approx SLSA Build L2; L3 inside a reusable workflow) | 3 | SOON | `[auto]` `gh attestation verify` |
| S4 | OpenSSF Scorecard v5.5.0 workflow present; aggregate score band: >=9 -> 3; 7.0-8.9 -> 2; 5.0-6.9 -> 1; <5 -> 0 | 3 | SOON | `[auto]` workflow file + `scorecard` run |
| S5 | SBOM per release: SPDX 3.0.1 or CycloneDX 1.6/1.7, NTIA 7 minimum fields (N/A -> excluded for pre-release-only projects) | 2 | LATER | `[auto]` asset scan; `[rubric]` field check |

### 6. Security process (10 pts)

| ID | Item | Pts | Phase | Probe |
|---|---|---|---|---|
| P1 | `SECURITY.md`: supported-versions table + private reporting channel (`/security/advisories/new` or `security@`) + acknowledgment timeline. Scale 0-4 | 4 | NOW | `[rubric]` (starter: `assets/SECURITY-template.md`) |
| P2 | GitHub private vulnerability reporting enabled | 3 | NOW | `[auto]` `gh api repos/{o}/{r} --jq .security_and_analysis` / `[rubric]` |
| P3 | Every security fix ships a published advisory (no silent fixes). Scale 0-3 | 3 | SOON | `[rubric]` advisory history review |

### 7. CI/CD (15 pts)

| ID | Item | Pts | Phase | Probe |
|---|---|---|---|---|
| C1 | Pipeline stages lint -> test -> build -> sign -> publish. Scale 0-3 | 3 | SOON | `[rubric]` workflow review |
| C2 | Every third-party `uses:` pinned to a full 40-char commit SHA (tag as trailing comment); Dependabot bumps SHAs | 4 | NOW | `[auto]` `grep -E 'uses:' workflows \| grep -vE '@[0-9a-fA-F]{40}([^0-9a-fA-F]\|$)'` must be empty (excluding `./` and `docker://`) |
| C3 | Top-level `permissions:` on every workflow; least-privilege with per-job elevation only (`contents: write` release, `id-token: write` OIDC, `security-events: write` SARIF) | 3 | NOW | `[auto]` `grep -q '^permissions:'` per file; `[rubric]` elevation review |
| C4 | No `permissions: write-all`; no floating mutable tags (`@vN`, `@main`) on the release path | 2 | NOW | `[auto]` `! grep -rEq 'permissions:[[:space:]]*write-all' workflows` |
| C5 | Release artifacts built only by CI (no hand-attached assets). Scale 0-3 | 3 | SOON | `[rubric]` + provenance check |

Total: 20 + 15 + 15 + 10 + 15 + 10 + 15 = **100**.

