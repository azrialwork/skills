<!--
  02-conventional-commits.md -- Reference for git-workflow.

  Conventional Commits v1.0.0 essentials: the format, the critical
  distinction between spec-mandated rules and this skill's stricter
  house rules, the inline SemVer mapping, and working-loop hygiene.
  Verified against conventionalcommits.org/en/v1.0.0/ on 2026-10-13.
  Read when writing or linting commit messages.
-->

# Conventional Commits

Spec: v1.0.0 (conventionalcommits.org). The commit message becomes
machine-readable, which makes changelogs and version bumps automatable.

## Format

```
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

## Spec-mandated rules (from the spec's 16 rules)

These hold for any tool claiming Conventional Commits compliance:

1. The subject is `<type>` + OPTIONAL scope + OPTIONAL `!` + REQUIRED
   terminal colon and space.
2. `feat` MUST mark a new feature; `fix` MUST mark a bug fix. **These
   are the only two types the spec defines.**
3. A scope MAY follow the type: a noun in parentheses naming a section
   of the codebase, e.g. `fix(parser):`.
4. The description MUST immediately follow the colon and space.
5. A body MAY follow, beginning one blank line after the description;
   it is free-form.
6. Footers MAY follow one blank line after the body. Each footer is
   `Token: value` or `Token #value` (git-trailer format).
7. A footer token MUST use `-` instead of whitespace (`Acked-by`); the
   only exception is `BREAKING CHANGE`. `BREAKING-CHANGE` is synonymous.
8. Breaking changes MUST be marked in the type/scope prefix (`!`
   immediately before the `:`) or as a footer entry. With `!`, the
   `BREAKING CHANGE:` footer MAY be omitted and the description serves
   as the break's description.
9. Parsing is case-insensitive **except** `BREAKING CHANGE`, which MUST
   be uppercase.
10. Types other than `feat`/`fix` are allowed and have **no implicit
    SemVer effect** (unless they carry a breaking change). The familiar
    extra types come from the **Angular convention via commitlint's
    `config-conventional`**, not from the spec: `build`, `chore`, `ci`,
    `docs`, `style`, `refactor`, `perf`, `test`, `revert`.

## Skill-strict rules (narrower than the spec; enforced by the linter)

`scripts/commit-lint.sh` adds house rules the spec does not require.
They narrow the spec; they do not conflict with it:

- Type must be one of the 11 known types above, lowercase.
- Description starts lowercase, never ends with a period, max 72 chars.
- Scope, when present, must be non-empty.
- Body lines wrap at 72 chars.
- `!` without a `BREAKING CHANGE` footer anywhere in the message is a
  warning (not a failure).

A commit is "conventional" for this skill iff `commit-lint.sh` exits 0.

## SemVer mapping (the point of the types; defined inline)

- `fix:` -> PATCH bump.
- `feat:` -> MINOR bump.
- `!` after type/scope, or a `BREAKING CHANGE:` footer (on any type) ->
  MAJOR bump.
- Any other type without a breaking change -> no version change.

With tooling (semantic-release, release-please), the next version is
derived purely from commit types since the last tag. No human picks the
number. The computable rule: scan commits since the last tag; any
breaking change -> MAJOR; else any `feat` -> MINOR; else any `fix` ->
PATCH; else no release.

## Spec FAQ notes (load-bearing for the workflow)

- **Squash workflows:** when maintainers squash-merge, they may clean up
  the commit message at merge time -- casual contributors are not
  required to write perfect messages on every branch commit. Consequence:
  in squash-merge repos, lint the PR title / squash message, not the
  branch commits.
- **Reverts:** the spec defines no revert semantics; the recommendation
  is the `revert` type plus a footer referencing the reverted SHAs,
  e.g. `Refs: 676104e, a215868`.

## Working-loop hygiene

- **Never commit on a dirty main.** Sync before starting work:
  `git pull --rebase` (or fetch, then rebase onto the integration
  branch). Push promptly after the commit lands.
- A commit message is a contract with future readers: vague subjects
  (`fix bug`, `update`, `WIP`) are rejected by the linter for a reason.

## Examples

Good:
- `feat: add retry with exponential backoff to sync client`
- `fix(auth): reject expired tokens instead of crashing`
- `docs: document the new branch protection rules`
- `refactor: extract checksum verification into verify()`
- `feat!: require Node 20 as the minimum runtime`
- `feat(api)!: drop v1 endpoints`

Bad:
- `fix bug` (no type colon, says nothing)
- `update` (not a type, says nothing)
- `WIP` (a diary entry, not a commit message)
- `feat: Added new feature` (past tense, uppercase start, says nothing)
