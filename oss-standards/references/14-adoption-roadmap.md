<!--
  14-adoption-roadmap.md -- Reference for oss-standards.

  Prioritized adoption order for a tiny single-binary distributor repo
  (builds one native binary in CI -> GitHub Releases -> piped
  installer). Apply NOW before SOON, SOON before LATER. Adapt the
  phases to other repo shapes; keep the ordering principle.
-->

# Adoption roadmap

## Ordering rules

INPUT: the repo's current state (from `scripts/repo-audit.sh`).

1. IF any NOW item is missing THEN fix ALL missing NOW items before touching any SOON item.
2. IF all NOW items pass THEN work SOON items in listed order.
3. IF all NOW and SOON items pass THEN work LATER items as the project grows.
4. IF an item appears on the SKIP list for this repo shape THEN do not adopt it, ever.
5. NEVER start a LATER item while a NOW item is missing -- a signed SBOM on a repo with no LICENSE is theater, not professionalism.

## NOW (before first public release -- hours of work, foundational trust)

1. **POSIX `sh` + `set -eu` installer** -- maximal installable population across Unix-like platforms; strictness turns silent corruption into loud failure.
2. **SHA256SUMS verification in install.sh (fail-closed)** -- the single highest-value security line; publish SHA256SUMS next to the tarball.
3. **OSI-approved LICENSE at root + SPDX identifier in README.**
4. **README: pitch + badges + installation + quickstart + license** -- the 60-second trust test.
5. **CHANGELOG.md (Keep a Changelog, `[Unreleased]`) + SemVer tags `vX.Y.Z`.**
6. **CI: shellcheck + shfmt + build on every PR.**
7. **curl|bash hygiene:** `--proto '=https' --tlsv1.2 -fsSL`, no sudo, never edit rc files blindly (print PATH instructions), `mktemp -d` + `trap` cleanup, `--help` / `--version`.
8. **GitHub Actions: `permissions: contents: read` default + SHA-pinned actions.**
9. **SECURITY.md** (15 lines: private reporting channel + supported versions); enable GitHub private vulnerability reporting.
10. **Dependabot** (`github-actions` ecosystem) from day 1.

## SOON (first month -- visible maturity)

11. **minisign-sign SHA256SUMS**; embed/ship `minisign.pub`.
12. **GitHub Artifact Attestations / SLSA provenance** on releases (~10 lines of YAML, approx SLSA Build L2/L3).
13. **bats installer tests** on a container matrix covering the supported platforms (glibc-based, musl-based, and minimal POSIX environments).
14. **CONTRIBUTING.md + issue/PR templates + CODEOWNERS.**
15. **Conventional Commits + release automation** (release-please or git-cliff).
16. **Completions + man page** (generated from `--help`).
17. **OpenSSF Scorecard workflow + Best Practices badge (Passing).**
18. **docs/adr/ habit** -- record the big decisions while fresh.

## LATER (as the project grows)

19. **SBOM per release** (Syft -> CycloneDX/SPDX, attached to release).
20. **Reproducible builds** (pinned toolchain + `SOURCE_DATE_EPOCH`).
21. **CODE_OF_CONDUCT.md** (Contributor Covenant 3.0) when a community exists.
22. **REUSE 3.3 compliance** when per-file licensing matters.
23. **DCO (`Signed-off-by`)** when outside contributions arrive.
24. **Docs site / Diataxis-structured `docs/`** when README passes ~200 lines.
25. **Deprecation/EOL policy** written down when v2 looms.

## SKIP (for this repo shape)

- **CLA infrastructure** -- no relicensing plans; DCO-if-anything.
- **Full l10n** (gettext catalogs) -- UTF-8 + NO_COLOR readiness is enough.
- **ISO/IEC 25010 as a management system** -- reference its vocabulary; do not run the repo by it.
- **Fuzzing / SAST-heavy gates** -- disproportionate for a downloader script + static binary on day one.
- **Multi-platform CI matrix beyond the target set** -- test what you ship, not the world.

## How to use this roadmap

1. Audit the repo: run `scripts/repo-audit.sh <repo-dir>`.
2. List every missing NOW item; fix them in the listed order (ordering rule 1).
3. THEN move to SOON; THEN LATER (ordering rules 2-3).
4. IF an item is on SKIP THEN skip it permanently (ordering rule 4).
