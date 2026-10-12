<!--
  02-conventional-commits.md -- Reference for git-workflow.

  Conventional Commits spec essentials: format, types, breaking changes,
  and why the types make version numbers computable. Read when writing
  or linting commit messages.
-->

# Conventional Commits

Spec: v1.0.0 (conventionalcommits.org). The commit message becomes
machine-readable, which makes changelogs and version bumps automatable.

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- **type:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`,
  `build`, `ci`, `chore`, `revert`.
- **description:** imperative mood, lowercase start, no trailing period,
  ~50 chars max. Says what the change does, not what was done.
- **scope:** optional noun naming the area (`api`, `auth`, `docs`).
- **breaking change:** append `!` after type/scope (`feat!: drop Node 14`)
  and/or a `BREAKING CHANGE:` footer.

## SemVer mapping (the point of the types)

- `fix:` -> PATCH bump.
- `feat:` -> MINOR bump.
- `!` / `BREAKING CHANGE:` -> MAJOR bump.
- Everything else -> no version change.

With tooling like semantic-release, the next version is derived purely
from commit types since the last tag. No human picks the number.

## Examples

Good:
- `feat: add retry with exponential backoff to sync client`
- `fix(auth): reject expired tokens instead of crashing`
- `docs: document the new branch protection rules`
- `refactor: extract checksum verification into verify()`
- `feat!: require Node 20 as the minimum runtime`

Bad:
- `fix bug` (no type colon, says nothing)
- `update` (not a type, not imperative, says nothing)
- `WIP` (not a commit message, it is a diary entry)
- `feat: Added new feature` (past tense, says nothing specific)

## Rules enforced by scripts/commit-lint.sh

1. Matches `<type>(<scope>)?: <description>` or `<type>(<scope>)!:`.
2. Type is in the known list.
3. Description is non-empty, starts lowercase, no trailing period,
   72 chars max.
4. Body lines (if any) wrap at 72 chars.
