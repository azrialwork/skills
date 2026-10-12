<!--
  06-repo-structure.md -- Reference for oss-standards.

  Covers: professional root layout, automation, licensing files, and repo
  hygiene. Read when creating or auditing a repository.
-->

# Repository structure

## Root vocabulary (confirmed across starship, ripgrep, fzf, mise, eza)

**Near-universal:**
- `README.md` -- the front door (see `07-readme.md`).
- `LICENSE` (or `LICENSE-MIT`, `UNLICENSE`, `COPYING`) -- full license text.
  License detectors (GitHub licensee, OpenSSF Scorecard) look here.
- `.github/` -- CI + community automation.
- `.gitignore` -- build outputs, editor files, `.env`.
- `CHANGELOG.md` -- Keep a Changelog format, with `## [Unreleased]`.

**For projects accepting contributions:**
- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` (Contributor Covenant),
  `SECURITY.md` (15 lines minimum -- see `11-security-process.md`).

**Supporting dirs:** `.github/workflows/`, `.github/ISSUE_TEMPLATE/`,
`.github/PULL_REQUEST_TEMPLATE.md`, `.github/dependabot.yml`,
`docs/`, `tests/`, `scripts/`, `completions/`, `man/`,
`.editorconfig`, `.gitattributes`, `.shellcheckrc` (non-negotiable if
you ship shell scripts).

## Mandatory vs optional (tiny single-binary repo)

| File | Verdict |
|---|---|
| `README.md`, `LICENSE`, `.gitignore`, `.github/workflows/ci.yml` | Mandatory |
| `install.sh` at root | Mandatory (it is the product surface) |
| `CHANGELOG.md` + SemVer tags | Mandatory (cheap, high trust) |
| `SECURITY.md` | Strongly recommended (Scorecard + trust) |
| `CONTRIBUTING.md` | Recommended once outside contributors appear |
| `CODE_OF_CONDUCT.md` | Optional until a community exists |
| Issue/PR templates, `CODEOWNERS`, dependabot | Add as needed; dependabot recommended from day 1 |
| `docs/`, `man/`, `completions/` | Optional at first; mandatory as the project grows |

## Automation

- **CI on every PR:** lint + test + build (shellcheck, shfmt, test suites
  across OSes).
- **Release automation:** GoReleaser (Go), release-please (multi-language,
  PR-based), semantic-release (JS), git-cliff (changelog from
  Conventional Commits).
- **Dependabot** for `github-actions` + package ecosystems.

## Hygiene

- **Binaries NEVER in git** -- release assets live in GitHub Releases
  (Scorecard `Binary-Artifacts` penalizes committed binaries).
- `.gitattributes`: `* text=auto`, scripts `eol=lf` (a CRLF-corrupted
  install.sh is a real failure mode on Windows-edited repos).
- `CODEOWNERS`: even `* @you` documents the bus factor.
- Prune merged branches; no vendored dependency tarballs (use lockfiles).

## Anti-patterns

- No LICENSE (legally unusable; corporate users walk away).
- README-only repo with no CI and no changelog.
- `.gitignore` missing build dirs (committed `target/` / `dist/` bloat).
