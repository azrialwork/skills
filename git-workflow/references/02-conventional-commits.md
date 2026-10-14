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
> Why: Machine-readable history is the only thing that lets changelogs and version bumps compute themselves instead of being hand-written fiction.

```
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

## Spec-mandated rules (from the spec's 16 rules)
> Why: Tools across the ecosystem parse the same two types, so drifting from the spec silently breaks every downstream consumer.

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
> Why: The stricter house rules exist because linted consistency is what makes a hundred commits scannable in one sitting.

`scripts/commit-lint.sh` adds house rules the spec does not require.
They narrow the spec; they do not conflict with it:

- Type MUST be one of the 11 known types above, lowercase.
- Description MUST start lowercase, MUST NOT end with a period, and
  MUST be at most 72 chars.
- Scope, when present, MUST be non-empty.
- Body lines MUST wrap at 72 chars.
- `!` without a `BREAKING CHANGE` footer anywhere in the message is a
  warning (not a failure).

A commit is "conventional" for this skill IFF `commit-lint.sh` exits 0.

## SemVer mapping (the point of the types; defined inline)
> Why: When types map to versions automatically, nobody argues about numbers and releases stop depending on someone's memory.

- `fix:` -> PATCH bump.
- `feat:` -> MINOR bump.
- `!` after type/scope, or a `BREAKING CHANGE:` footer (on any type) ->
  MAJOR bump.
- Any other type without a breaking change -> no version change.

Computable rule: scan commits since the last tag; IF any breaking
change THEN MAJOR; ELSE IF any `feat` THEN MINOR; ELSE IF any `fix`
THEN PATCH; ELSE no release. With tooling (semantic-release,
release-please), the next version is derived purely from commit types
since the last tag. No human picks the number.

## Spec FAQ notes (load-bearing for the workflow)
> Why: Linting the wrong place in a squash workflow rejects good work and trains contributors to ignore the linter entirely.

- **Squash workflows:** IF the repo uses squash-merge THEN lint the PR
  title / squash message, NOT the branch commits. Maintainers may clean
  up the commit message at merge time -- casual contributors are not
  required to write perfect messages on every branch commit.
- **Reverts:** the spec defines no revert semantics. IF reverting THEN
  use the `revert` type plus a footer referencing the reverted SHAs,
  e.g. `Refs: 676104e, a215868`.

## Working-loop hygiene
> Why: A dirty main is where merge conflicts are born; syncing first is cheaper than untangling them later.

- IF main is dirty THEN sync BEFORE starting work: `git pull --rebase`
  (or fetch, then rebase onto the integration branch). NEVER commit on
  a dirty main. ALWAYS push promptly after the commit lands.
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
