<!--
  13-docs-community.md -- Reference for oss-standards.

  Covers: documentation standards (Diataxis, ADRs, man pages) and
  community files (CoC, CONTRIBUTING, CODEOWNERS). Read when the project
  outgrows README-only docs or gains contributors.
-->

# Documentation and community standards

## Diataxis (diataxis.fr)

Documentation serves four user needs in four forms:

| Form | Need | Example |
|---|---|---|
| Tutorials | Learning (study) | "Install and run your first X" |
| How-to guides | Goals (work) | "How to sign a release" |
| Reference | Information (work) | CLI flags, config schema, `--help` |
| Explanation | Understanding (study) | "Why POSIX sh, not bash" (ADRs) |

For a tiny repo: README = tutorial + how-to (quickstart);
`--help` output = reference. Split into `docs/` when the README
passes ~200 lines. Docs live in the repo as Markdown, reviewed like
code, built by CI (docs-as-code).

## ADRs -- Architecture Decision Records

- Numbered, immutable `docs/adr/NNNN-title.md`: Context -> Decision ->
  Consequences (Michael Nygard's format).
- Write one for each significant, hard-to-reverse decision (shell
  choice, signing scheme, license choice) while it is fresh.

## Man pages

- Professional CLIs ship man pages (`man/` dir -- fzf, mise, eza all do).
- Generate from `--help` (clap_mangen, cobra, help2man), never hand-write.

## Contributor Covenant Code of Conduct

- The de-facto OSS code of conduct; current version 3.0 (2025-07-28),
  though most projects still carry 2.1 -- either is defensible.
- Adopt when a community exists, not before (roadmap LATER).

## CONTRIBUTING.md contents

Build prerequisites, dev setup, how to run tests/lint, commit-message
convention (link Conventional Commits), PR process (template, review
expectations), DCO sign-off if used, release process pointer.

## Governance for small projects

- Single-maintainer / BDFL is the norm and is fine -- **document it**:
  "Decisions by maintainer (@you); PRs welcome; lazy consensus on
  non-breaking changes."
- `CODEOWNERS`: `* @yourname` minimum; per-directory owners as the repo
  grows. GitHub auto-requests reviews; documents the bus factor.

## Minimum i18n/a11y

- UTF-8 everywhere, respect `NO_COLOR`, no hardcoded date/number formats.
  Full gettext catalogs are SKIP for a CLI (roadmap).

## Anti-patterns

- Docs that duplicate `--help` and drift from it.
- CONTRIBUTING.md that nobody follows because CI does not enforce it.
- Adopting a CoC with no enforcement contact listed.
