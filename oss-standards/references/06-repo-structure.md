<!--
  06-repo-structure.md -- Reference for oss-standards.

  Covers: professional root layout, automation, licensing files, and repo
  hygiene. Read when creating or auditing a repository.
-->

# Repository structure

## Algorithm
> Why: A repo's root layout is read before a single line of code -- a missing license or CI tells a corporate evaluator to walk away in under a minute.

INPUT: the repository root (tiny single-binary shape unless stated otherwise).

1. **Lay out the root.** The following MUST exist (confirmed across starship, ripgrep, fzf, mise, eza):
   - `README.md` -- the front door (see `07-readme.md`).
   - `LICENSE` (or `LICENSE-MIT`, `UNLICENSE`, `COPYING`) -- full license text. License detectors (GitHub licensee, OpenSSF Scorecard) look here.
   - `.github/` -- CI + community automation.
   - `.gitignore` -- build outputs, editor files, `.env`.
   - `CHANGELOG.md` -- Keep a Changelog format, with `## [Unreleased]`.
2. **Add contribution files conditionally.** IF the project accepts contributions THEN add `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` (Contributor Covenant), and `SECURITY.md` (15 lines minimum -- see `11-security-process.md`). ELSE skip them.
3. **Add supporting dirs as needed:** `.github/workflows/`, `.github/ISSUE_TEMPLATE/`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/dependabot.yml`, `docs/`, `tests/`, `scripts/`, `completions/`, `man/`, `.editorconfig`, `.gitattributes`, `.shellcheckrc` (non-negotiable IF the repo ships shell scripts).
4. **Apply the mandatory/optional verdicts** for a tiny single-binary repo:
   - MANDATORY: `README.md`, `LICENSE`, `.gitignore`, `.github/workflows/ci.yml`, `install.sh` at root (it is the product surface), `CHANGELOG.md` + SemVer tags.
   - STRONGLY RECOMMENDED: `SECURITY.md` (Scorecard + trust).
   - IF outside contributors appear THEN add `CONTRIBUTING.md`.
   - IF a community exists THEN add `CODE_OF_CONDUCT.md`; ELSE skip.
   - Add issue/PR templates and `CODEOWNERS` as needed; enable dependabot (`github-actions` ecosystem) from day 1.
   - `docs/`, `man/`, `completions/`: optional at first; MANDATORY as the project grows.
5. **Automate.** CI MUST run on every PR: lint + test + build (shellcheck, shfmt, test suites across OSes). Release automation by language: GoReleaser (Go), release-please (multi-language, PR-based), semantic-release (JS), git-cliff (changelog from Conventional Commits). Enable Dependabot for `github-actions` + package ecosystems.
6. **Enforce hygiene.** Binaries MUST NEVER be committed to git -- release assets live in GitHub Releases (Scorecard `Binary-Artifacts` penalizes committed binaries). `.gitattributes` MUST set `* text=auto` and `eol=lf` for scripts (a CRLF-corrupted install.sh is a real failure mode on Windows-edited repos). `CODEOWNERS` MUST exist (`* @you` minimum documents the bus factor). Prune merged branches. NEVER vendor dependency tarballs; use lockfiles.

## FLAG on sight (FAIL)
> Why: No LICENSE does not mean "free to use" -- legally it means "all rights reserved," so the project is unusable by anyone with a legal department.

- No LICENSE (legally unusable; corporate users walk away).
- README-only repo with no CI and no changelog.
- `.gitignore` missing build dirs (committed `target/` / `dist/` bloat).
