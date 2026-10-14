<!--
  08-versioning-releases.md -- Reference for oss-standards.

  Covers: SemVer, Conventional Commits, Keep a Changelog, release
  automation, and deprecation policy. Read when setting up versioning.
-->

# Versioning and releases

## Algorithm
> Why: Version numbers are a contract with every downstream user -- a breaking change smuggled into a MINOR release breaks builds you will never hear about.

INPUT: the repo's tags, CHANGELOG.md, and release workflow.

1. **Semantic Versioning 2.0.0 (semver.org).** Format MUST be `MAJOR.MINOR.PATCH` (+ optional `-prerelease`, `+build`). MAJOR = incompatible changes; MINOR = backward-compatible additions; PATCH = backward-compatible fixes. On bump, reset lower components (1.4.2 + feature -> 1.5.0). Git tags MUST be `v1.2.3` matching the changelog; one source of truth for the version number.
2. **Conventional Commits 1.0.0 (conventionalcommits.org).** Grammar MUST be `<type>[scope][!]: <description>`; `feat` -> MINOR, `fix` -> PATCH, `!` or `BREAKING CHANGE` footer -> MAJOR. Enforce with commitlint in CI. This enables automated changelog generation and SemVer-bump computation.
3. **Keep a Changelog 1.1.0 (keepachangelog.com/en/1.1.0).** `CHANGELOG.md` MUST be human-curated with a `## [Unreleased]` section, categories ONLY from {Added, Changed, Deprecated, Removed, Fixed, Security}, ISO-8601 dates, and SemVer headings. Changelog (in-repo, cumulative, human-curated) is not release notes (per-release, may be generated): keep both; generate the latter from the former.
4. **Release automation.** Select by language: IF Go THEN GoReleaser (builds, packages, signs, publishes -- fzf uses it). ELSE IF JS THEN semantic-release (fully automated from conventional commits). ELSE use release-please (PR-based, per-language strategies -- starship uses it) or git-cliff (changelog from conventional commits; mise uses `cliff.toml`). GitHub Releases convention: tag `vX.Y.Z` -> release titled `vX.Y.Z` with the changelog excerpt as notes; attach build artifacts + `SHA256SUMS` (+ signatures / provenance). Artifacts MUST be built ONLY by CI, NEVER by hand.
5. **Deprecation policy.** Deprecate in a MINOR release (warnings + docs marked deprecated); remove in the next MAJOR at the earliest. Give consumers at least one MINOR release of notice.

## FLAG on sight (FAIL)
> Why: Hand-built artifacts and mismatched tags mean nobody, including you, can reproduce what users actually installed.

- Tags that do not match any changelog entry.
- Hand-built release artifacts attached to a release.
- Breaking changes in a MINOR/PATCH release.
