<!--
  13-docs-community.md -- Reference for oss-standards.

  Covers: documentation standards (Diataxis, ADRs, man pages) and
  community files (CoC, CONTRIBUTING, CODEOWNERS). Read when the project
  outgrows README-only docs or gains contributors.
-->

# Documentation and community standards

## Algorithm
> Why: Documentation is written once and read hundreds of times, so every hour spent structuring it pays back in support questions you never have to answer.

INPUT: the repo's docs and contributor state.

1. **Structure docs by Diataxis (diataxis.fr).** Every page serves exactly one of four needs:

   | Form | Need | Example |
   |---|---|---|
   | Tutorials | Learning (study) | "Install and run your first X" |
   | How-to guides | Goals (work) | "How to sign a release" |
   | Reference | Information (work) | CLI flags, config schema, `--help` |
   | Explanation | Understanding (study) | "Why POSIX sh, not bash" (ADRs) |

   For a tiny repo: README = tutorial + how-to (quickstart); `--help` output = reference. IF the README passes ~200 lines THEN split into `docs/`. Docs live in the repo as Markdown, are reviewed like code, and are built by CI (docs-as-code).
2. **Record ADRs.** IF a decision is significant AND hard to reverse (shell choice, signing scheme, license choice) THEN write `docs/adr/NNNN-title.md` while it is fresh, in Michael Nygard's format: Context -> Decision -> Consequences. ADRs are numbered and immutable.
3. **Ship man pages.** Professional CLIs ship them (`man/` dir -- fzf, mise, eza all do). Generate from `--help` (clap_mangen, cobra, help2man); NEVER hand-write.
4. **Code of Conduct.** IF a community exists THEN adopt the Contributor Covenant (current 3.0, 2025-07-28; most projects still carry 2.1 -- either is defensible). IF no community exists yet THEN do not adopt (roadmap LATER).
5. **Write CONTRIBUTING.md.** It MUST cover: build prerequisites, dev setup, how to run tests/lint, commit-message convention (link Conventional Commits), PR process (template, review expectations), DCO sign-off if used, release process pointer.
6. **Document governance.** Single-maintainer / BDFL is the norm and is fine -- but it MUST be written down: "Decisions by maintainer (@you); PRs welcome; lazy consensus on non-breaking changes." `CODEOWNERS`: `* @yourname` minimum; per-directory owners as the repo grows. GitHub auto-requests reviews; this documents the bus factor.
7. **Minimum i18n/a11y.** UTF-8 everywhere; respect `NO_COLOR`; NEVER hardcode date/number formats. Full gettext catalogs are SKIP for a CLI (roadmap).

## FLAG on sight (FAIL)
> Why: A CONTRIBUTING.md that CI does not enforce is fiction -- contributors learn the real process from the first rejected PR, not from the document.

- Docs that duplicate `--help` and drift from it.
- CONTRIBUTING.md that nobody follows because CI does not enforce it.
- Adopting a CoC with no enforcement contact listed.
