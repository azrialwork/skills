<!--
  14-adoption-roadmap.md -- Reference for oss-standards.

  Prioritized adoption order for a tiny single-binary distributor repo
  (builds one native binary in CI -> GitHub Releases -> curl|bash
  installer). Apply NOW before SOON, SOON before LATER. Adapt the
  phases to other repo shapes; keep the ordering principle.
-->

# Adoption roadmap

## NOW (before first public release -- hours of work, foundational trust)

1. **POSIX `sh` + `set -eu` installer** -- maximal installable population
   incl. Termux; strictness turns silent corruption into loud failure.
2. **SHA256SUMS verification in install.sh (fail-closed)** -- the single
   highest-value security line; publish SHA256SUMS next to the tarball.
3. **OSI-approved LICENSE at root + SPDX identifier in README.**
4. **README: pitch + badges + installation + quickstart + license** --
   the 60-second trust test.
5. **CHANGELOG.md (Keep a Changelog, `[Unreleased]`) + SemVer tags
   `vX.Y.Z`.**
6. **CI: shellcheck + shfmt + build on every PR.**
7. **curl|bash hygiene:** `--proto '=https' --tlsv1.2 -fsSL`, no sudo,
   never edit rc files blindly (print PATH instructions),
   `mktemp -d` + `trap` cleanup, `--help` / `--version`.
8. **GitHub Actions: `permissions: contents: read` default + SHA-pinned
   actions.**
9. **SECURITY.md** (15 lines: private reporting channel + supported
   versions); enable GitHub private vulnerability reporting.
10. **Dependabot** (`github-actions` ecosystem) from day 1.

## SOON (first month -- visible maturity)

11. **minisign-sign SHA256SUMS**; embed/ship `minisign.pub`.
12. **GitHub Artifact Attestations / SLSA provenance** on releases
    (~10 lines of YAML, approx SLSA Build L2/L3).
13. **bats installer tests** on a docker distro matrix
    (ubuntu/debian/alpine/fedora + a Termux-ish check).
14. **CONTRIBUTING.md + issue/PR templates + CODEOWNERS.**
15. **Conventional Commits + release automation** (release-please or
    git-cliff).
16. **Completions + man page** (generated from `--help`).
17. **OpenSSF Scorecard workflow + Best Practices badge (Passing).**
18. **docs/adr/ habit** -- record the big decisions while fresh.

## LATER (as the project grows)

19. **SBOM per release** (Syft -> CycloneDX/SPDX, attached to release).
20. **Reproducible builds** (pinned toolchain + `SOURCE_DATE_EPOCH`).
21. **CODE_OF_CONDUCT.md** (Contributor Covenant 3.0) when a community
    exists.
22. **REUSE 3.3 compliance** when per-file licensing matters.
23. **DCO (`Signed-off-by`)** when outside contributions arrive.
24. **Docs site / Diataxis-structured `docs/`** when README passes
    ~200 lines.
25. **Deprecation/EOL policy** written down when v2 looms.

## SKIP (for this repo shape)

- **CLA infrastructure** -- no relicensing plans; DCO-if-anything.
- **Full l10n** (gettext catalogs) -- UTF-8 + NO_COLOR readiness is enough.
- **ISO/IEC 25010 as a management system** -- reference its vocabulary;
  do not run the repo by it.
- **Fuzzing / SAST-heavy gates** -- disproportionate for a downloader
  script + static binary on day one.
- **Multi-platform CI matrix beyond the target set** -- test what you
  ship, not the world.

## How to use this roadmap

Audit the repo (`scripts/repo-audit.sh`), list every missing NOW item,
fix them in order, then move to SOON. Do not start LATER items while
NOW items are missing -- a signed SBOM on a repo with no LICENSE is
theater, not professionalism.
