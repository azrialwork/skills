<!--
  04-releasing.md -- Reference for git-workflow.

  Cutting releases: tagging discipline, GitHub Releases, changelog
  generation, the computable version pipeline, and hotfixes. Current
  as of 2026-10-13. Read when shipping a version.
-->

# Releasing

## Tagging algorithm
> Why: A moved or lightweight tag silently changes what consumers run, and they will blame you for a breakage you cannot reproduce.

1. Create an annotated tag: `git tag -a v1.2.3 -m "Release v1.2.3"`.
   Annotated tags are full git objects (tagger, date, message,
   GPG-signable); lightweight tags are bare ref pointers and are
   unsuitable for releases.
2. VERIFY: `git cat-file -t <name>` MUST print `tag`. IF it prints
   `commit` THEN the tag is lightweight: delete it and redo step 1.
3. Tag names follow SemVer with a `v` prefix: `v1.2.3`. Pre-releases:
   `v1.0.0-rc.1`, `v1.0.0-beta.1`. (Driessen's original post tags bare
   `1.2`; this skill standardizes on the `v` prefix, which is the
   dominant convention and sorts with `git tag --sort=-v:refname`.)
4. Tag the exact commit that passed CI.
5. Push the tag: `git push origin v1.2.3`. Tags are NOT pushed by
   default.
6. NEVER move a release tag. Consumers pin to it; moving it silently
   changes what they run.
7. IF others install from your releases THEN sign the tag
   (`git tag -s`; Driessen's post itself suggests `-s`/`-u`).

## GitHub Releases
> Why: Release notes written by hand rot; notes generated from commits stay true because they cannot drift from what shipped.

1. Push the tag, then create the release (or create it in the web UI,
   which creates the tag).
2. Title the release `v1.2.3`. Write notes grouped by type (Features,
   Fixes, Docs) -- generated from conventional commits.
3. IF the project ships binaries THEN attach build artifacts (tarballs,
   checksums). GitHub can auto-generate notes from merged PRs; CI can
   trigger on `release`.

## Changelog generation
> Why: The changelog is a user-facing contract, and a missing entry is a silent breaking change in trust.

Algorithm: collect `feat`/`fix` subjects since the last tag, grouped
by type. The discipline that makes it possible is the commit format,
not the tool.

| Tool | Changelog | Version bump | Notes |
|---|---|---|---|
| release-please (Google) | yes | yes | Release-PR workflow, monorepo support |
| semantic-release | yes | yes | Pure commit -> version -> changelog -> publish pipeline |
| git-cliff (Rust) | yes | no | TOML-configured templates, fast |
| conventional-changelog-cli | yes | no | One-shot generation |
| changesets | yes | yes | Manual entries, npm only |
| standard-version | yes | yes | **Deprecated** -- IF using it THEN migrate to release-please |

## The computable pipeline
> Why: Every hand-written version number is a negotiation; a computed one is a fact nobody can argue with.

```text
conventional commits -> linter (CI) -> version computed from types
-> changelog generated -> tag created -> GitHub Release published
```

Version computation (needs no outside reference): scan commits since
the last tag. IF any breaking change (`!` or `BREAKING CHANGE:`) THEN
MAJOR; ELSE IF any `feat` THEN MINOR; ELSE IF any `fix` THEN PATCH;
ELSE no release. No human picks the number; no human writes the
changelog by hand.

Precondition: EVERY commit passes the linter. Hence
`scripts/commit-lint.sh` as a commit-msg hook or CI step (and PR-title
linting for squash-merge repos). IF any commit fails linting THEN the
pipeline output is untrustworthy: fix the commits first.

## Hotfixes
> Why: A hotfix outside the pipeline creates a version that matches nothing in history, and the next release inherits the lie.

1. Create a `fix:` commit on a release branch (or on `main` for
   trunk-based).
2. Release it as a PATCH bump IMMEDIATELY, through the same pipeline
   as any release (steps above), just faster.
3. NEVER hand-roll a hotfix outside the pipeline -- that is how
   versions stop matching reality.
