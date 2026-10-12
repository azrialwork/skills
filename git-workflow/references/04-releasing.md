<!--
  04-releasing.md -- Reference for git-workflow.

  Cutting releases: tagging discipline, GitHub Releases, changelog
  generation, and automation. Read when shipping a version.
-->

# Releasing

## Tagging

- Use annotated tags: `git tag -a v1.2.3 -m "Release v1.2.3"`.
  Annotated tags carry author, date, and message; lightweight tags do
  not and are unsuitable for releases.
- Tag names follow SemVer with a `v` prefix: `v1.2.3`.
- Tag the exact commit that passed CI. Never move a release tag.

## GitHub Releases

1. `git push origin v1.2.3` (or create the release in the web UI,
   which creates the tag).
2. Title the release `v1.2.3`; write notes grouped by type
   (Features, Fixes, Docs) -- generated from conventional commits.
3. Attach build artifacts (tarballs, checksums) when the project
   ships binaries.

## Changelog generation

With Conventional Commits, the changelog writes itself: collect
`feat`/`fix` subjects since the last tag, grouped by type. Tools
(`git-cliff`, `semantic-release`, `release-please`) automate this;
the discipline that makes it possible is the commit format, not the
tool.

## Release automation (the computable pipeline)

```
conventional commits -> linter (CI) -> version computed from types
-> changelog generated -> tag created -> GitHub Release published
```

No human picks the version number and no human writes the changelog
by hand. The human's job is the commit message; everything downstream
is derived. This only works if every commit passes the linter --
hence `scripts/commit-lint.sh` as a commit-msg hook or CI step.

## Hotfixes

A hotfix is a `fix:` commit on a release branch (or main, for
trunk-based), released as a PATCH bump immediately. It follows the
same pipeline as any release, just faster. Never hand-roll a hotfix
outside the pipeline -- that is how versions stop matching reality.
