<!--
  08-versioning-releases.md -- Reference for oss-standards.

  Covers: SemVer, Conventional Commits, Keep a Changelog, release
  automation, and deprecation policy. Read when setting up versioning.
-->

# Versioning and releases

## Semantic Versioning 2.0.0 (semver.org)

- Format `MAJOR.MINOR.PATCH` (+ optional `-prerelease`, `+build`).
- MAJOR = incompatible changes; MINOR = backward-compatible additions;
  PATCH = backward-compatible fixes. Reset lower components on bump
  (1.4.2 + feature -> 1.5.0).
- Git tags `v1.2.3` matching the changelog; one source of truth for the
  version number.

## Conventional Commits 1.0.0 (conventionalcommits.org)

- Grammar: `<type>[scope][!]: <description>`; `feat` -> MINOR,
  `fix` -> PATCH, `!` or `BREAKING CHANGE` footer -> MAJOR.
- Enables automated changelog generation and SemVer-bump computation.
- Enforce with commitlint in CI.

## Keep a Changelog 1.1.0 (keepachangelog.com/en/1.1.0)

- Human-curated `CHANGELOG.md`: `## [Unreleased]` section, categories
  `Added / Changed / Deprecated / Removed / Fixed / Security`,
  ISO-8601 dates, SemVer headings.
- Changelog (in-repo, cumulative, human-curated) is not release notes
  (per-release, may be generated). Keep both; generate the latter from
  the former.

## Release automation

- **release-please** (googleapis): PR-based, per-language strategies
  (starship uses it).
- **semantic-release** (JS): fully automated from conventional commits.
- **GoReleaser** (Go): builds, packages, signs, publishes (fzf uses it).
- **git-cliff**: changelog generator from conventional commits
  (mise uses `cliff.toml`).
- GitHub Releases conventions: tag `vX.Y.Z` -> release titled `vX.Y.Z`
  with the changelog excerpt as notes; attach build artifacts +
  `SHA256SUMS` (+ signatures / provenance). Artifacts are built **only**
  by CI, never by hand.

## Deprecation policy

- Deprecate in a MINOR release (warnings + docs marked deprecated);
  remove in the next MAJOR at the earliest. Give consumers at least one
  MINOR release of notice.

## Anti-patterns

- Tags that do not match any changelog entry.
- Hand-built release artifacts attached to a release.
- Breaking changes in a MINOR/PATCH release.
