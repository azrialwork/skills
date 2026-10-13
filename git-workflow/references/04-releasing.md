<!--
  04-releasing.md -- Reference for git-workflow.

  Cutting releases: tagging discipline, GitHub Releases, changelog
  generation, the computable version pipeline, and hotfixes. Current
  as of 2026-10-13. Read when shipping a version.
-->

# Releasing

## Tagging

- Use annotated tags: `git tag -a v1.2.3 -m "Release v1.2.3"`.
  Annotated tags are full git objects (tagger, date, message,
  GPG-signable); lightweight tags are bare ref pointers and are
  unsuitable for releases. Verify with `git cat-file -t <name>`:
  `tag` vs `commit`.
- Tag names follow SemVer with a `v` prefix: `v1.2.3`. Pre-releases:
  `v1.0.0-rc.1`, `v1.0.0-beta.1`. (Driessen's original post tags bare
  `1.2`; this skill standardizes on the `v` prefix, which is the
  dominant convention and sorts with `git tag --sort=-v:refname`.)
- Tag the exact commit that passed CI. Tags are not pushed by default:
  `git push origin v1.2.3`.
- **Never move a release tag.** Consumers pin to it; moving it silently
  changes what they run.
- Advanced: sign release tags (`git tag -s`; Driessen's post itself
  suggests `-s`/`-u`) when others install from your releases.

## GitHub Releases

1. Push the tag, then create the release (or create it in the web UI,
   which creates the tag).
2. Title the release `v1.2.3`. Write notes grouped by type (Features,
   Fixes, Docs) -- generated from conventional commits.
3. Attach build artifacts (tarballs, checksums) when the project ships
   binaries. GitHub can auto-generate notes from merged PRs; CI can
   trigger on `release`.

## Changelog generation

With Conventional Commits, the changelog writes itself: collect
`feat`/`fix` subjects since the last tag, grouped by type. The
discipline that makes it possible is the commit format, not the tool.

| Tool | Changelog | Version bump | Notes |
|---|---|---|---|
| release-please (Google) | yes | yes | Release-PR workflow, monorepo support |
| semantic-release | yes | yes | Pure commit -> version -> changelog -> publish pipeline |
| git-cliff (Rust) | yes | no | TOML-configured templates, fast |
| conventional-changelog-cli | yes | no | One-shot generation |
| changesets | yes | yes | Manual entries, npm only |
| standard-version | yes | yes | **Deprecated** -- migrate to release-please |

## The computable pipeline

```
conventional commits -> linter (CI) -> version computed from types
-> changelog generated -> tag created -> GitHub Release published
```

Version computation rule (defined inline; needs no outside reference):
scan commits since the last tag. Any breaking change (`!` or
`BREAKING CHANGE:`) -> MAJOR. Else any `feat` -> MINOR. Else any `fix`
-> PATCH. Else no release. No human picks the number and no human
writes the changelog by hand. This only holds if *every* commit passes
the linter -- hence `scripts/commit-lint.sh` as a commit-msg hook or
CI step (and PR-title linting for squash-merge repos).

## Hotfixes

A hotfix is a `fix:` commit on a release branch (or on `main` for
trunk-based), released as a PATCH bump immediately. It follows the
same pipeline as any release, just faster. Never hand-roll a hotfix
outside the pipeline -- that is how versions stop matching reality.
