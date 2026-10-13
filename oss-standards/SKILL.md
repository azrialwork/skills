---
name: oss-standards
description: Applies international open-source industry standards to a project. Covers professional POSIX-sh installer scripts (`install.sh` shell choice, strict mode, checksum verification, progress UX, PATH handling), repository structure, README anatomy, SemVer, Conventional Commits, SPDX licensing, SLSA and Sigstore supply-chain security, `SECURITY.md`, hardened CI/CD, and documentation standards; not for day-to-day branching decisions or commit-message style. Use when creating, reviewing, auditing, or upgrading an open-source repository, installer script, README, release process, or CI pipeline — run `scripts/repo-audit.sh` for a fast checklist pass — or when the user mentions industry standards, best practices, OpenSSF, SLSA, SBOM, or professionalizing a project.
---

<!--
  oss-standards -- SKILL.md

  Purpose: entry point for the oss-standards skill. States the skill's job,
  the workflow to follow, and the reference map. Detailed standards live in
  references/; keep this file lean and workflow-oriented.
-->

# oss-standards

Brings a project up to international open-source industry standards: the
installer script, the repository layout, the README, versioning, licensing,
supply-chain security, the security process, CI/CD, and documentation.

## When to use

- Starting a new open-source project and wanting it professional from day one.
- Auditing an existing repo or `install.sh` against industry standards.
- Writing or reviewing a piped (`curl`-to-shell) installer, a README, a SECURITY.md,
  or a release workflow.
- Adopting SemVer, Conventional Commits, SPDX, SLSA, Sigstore, SBOM,
  OpenSSF Scorecard, or similar standards.

## Workflow

1. **Clarify scope.** One engagement = one target (installer, repo layout,
   README, release process, or full audit). Ask which before starting.
2. **Audit first.** Run `scripts/repo-audit.sh <repo-dir>` for a fast
   checklist pass, or audit manually against the relevant reference.
3. **Prioritize with the roadmap.** Apply `references/14-adoption-roadmap.md`:
   fix NOW items before SOON, SOON before LATER. Never start with LATER.
4. **Apply standards.** Follow the matching reference file(s). Prefer the
   smallest change that satisfies the standard; do not gold-plate.
5. **Verify and score.** Re-run the audit script; confirm every NOW
   item passes. For a complete 0-100 compliance score, apply
   `references/15a-scoring-algorithm.md` (every requirement maps to an
   automated probe or an explicit human-rubric input).

## Reference map

| File | Covers |
|---|---|
| `references/01-install-sh-fundamentals.md` | POSIX sh vs bash, strict mode, reference installer dissections |
| `references/02-install-sh-security.md` | Checksum/signature verification, TLS hardening, trust model |
| `references/03-install-sh-robustness.md` | Platform matrix, curl/wget fallback, retry, temp hygiene, idempotency |
| `references/04-install-sh-ux.md` | Progress bars, spinners, colors, PATH handling, messages |
| `references/05-install-sh-testing.md` | shellcheck, shfmt, bats, CI distro matrix |
| `references/06-repo-structure.md` | Root layout, workflows, licensing files, hygiene |
| `references/07-readme.md` | Section order, badges, installation section, tone |
| `references/08-versioning-releases.md` | SemVer, Conventional Commits, changelog, release automation |
| `references/09-licensing-compliance.md` | SPDX, OSI, REUSE, DCO vs CLA, attribution |
| `references/10-supply-chain-security.md` | SLSA, Sigstore/cosign, Scorecard, reproducible builds, SBOM |
| `references/11-security-process.md` | SECURITY.md, coordinated disclosure, CVE flow |
| `references/12-cicd.md` | Pipeline stages, provenance, SHA-pinned actions, least privilege |
| `references/13-docs-community.md` | Diataxis, ADRs, man pages, CoC, CONTRIBUTING, CODEOWNERS |
| `references/14-adoption-roadmap.md` | NOW / SOON / LATER / SKIP prioritization |
| `references/15a-scoring-algorithm.md` | Standalone 0-100 compliance-scoring algorithm: bands, criteria, weights, gates, probes |
| `references/15b-scoring-appendix.md` | Scoring-algorithm appendix: anti-patterns, pseudocode, worked example, pinned standard versions |

Read a reference only when its topic is in scope. Do not preload all of them.

## Scripts and assets

- `scripts/repo-audit.sh` -- POSIX-sh checklist auditor for a repo directory.
  Reports PASS/FAIL per standard; exit nonzero on any NOW-item failure.
- `assets/SECURITY-template.md` -- minimal SECURITY.md starter (15 lines).
- `assets/install-sh-skeleton.sh` -- minimal installer skeleton with the
  standard idioms (strict mode, checksum, progress bar, trap cleanup).

## Guardrails

- Never weaken a security standard to simplify (no skipping checksums,
  no `curl | sudo bash`, no blind shell-rc edits).
- Do not recommend standards disproportionate to the project size; the
  roadmap's SKIP list exists for a reason.
- Every claim about a standard must name the standard and its source
  (e.g. "SemVer 2.0.0 -- semver.org"); never invent standard names.
- Anti-patterns to flag on sight: no strict mode, bashisms under
  `#!/bin/sh`, unguarded `rm -rf $var`, hardcoded `/usr/local`,
  binaries committed to git, missing LICENSE, a piped install as the only
  install method with no security note.
