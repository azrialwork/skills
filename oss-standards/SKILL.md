---
name: oss-standards
description: Applies international open-source industry standards to a project. Covers professional POSIX-sh installer scripts (`install.sh` shell choice, strict mode, checksum verification, progress UX, PATH handling), repository structure, README anatomy, SemVer, Conventional Commits, SPDX licensing, SLSA and Sigstore supply-chain security, `SECURITY.md`, hardened CI/CD, and documentation standards; not for day-to-day branching decisions or commit-message style. Use when creating, reviewing, auditing, or upgrading an open-source repository, installer script, README, release process, or CI pipeline: run `scripts/repo-audit.sh` for a fast checklist pass, or when the user mentions industry standards, established practices, OpenSSF, SLSA, SBOM, or professionalizing a project.
---

# oss-standards

Brings a project up to international open-source industry standards: the installer script, the repository layout, the README, versioning, licensing, supply-chain security, the security process, CI/CD, and documentation.

## Trigger

USE WHEN:
- Creating, reviewing, auditing, or upgrading an open-source repository, installer script, README, release process, or CI pipeline.
- The user mentions industry standards, established practices, OpenSSF, SLSA, SBOM, or professionalizing a project.

DO NOT USE WHEN:
- Day-to-day branching decisions or commit-message style (use git-workflow).

## Algorithm
> Why: Without a fixed sequence, reviewers gold-plate the easy parts and miss the foundational ones, so the repo looks professional while remaining untrustworthy.

INPUT: the target (installer, repo layout, README, release process, or full audit) and the repo directory.

1. **Clarify scope.** One engagement = one target. IF the user has not named the target THEN ask which one and WAIT. Allowed targets: installer, repo layout, README, release process, full audit.
2. **Audit first.** Run `scripts/repo-audit.sh <repo-dir>` for the checklist pass, or audit manually against the relevant reference. Record every PASS/FAIL.
3. **Flag anti-patterns on sight.** IF any of these appear THEN record as FAIL immediately: no strict mode, bashisms under `#!/bin/sh`, unguarded `rm -rf $var`, hardcoded `/usr/local`, binaries committed to git, missing LICENSE, a piped install as the only install method with no security note.
4. **Prioritize with the roadmap.** Apply `references/14-adoption-roadmap.md` in strict order: fix ALL NOW items before any SOON item, ALL SOON items before any LATER item. NEVER start with LATER.
5. **Apply standards.** Follow the matching reference file(s). IF two changes both satisfy the standard THEN apply the smaller one. NEVER add changes beyond what the standard requires (no gold-plating).
6. **Check proportionality.** BEFORE recommending a standard: consult the SKIP list in `references/14-adoption-roadmap.md`. IF the standard is on SKIP for this project size THEN do not recommend it.
7. **Verify and score.** Re-run the audit script. IF any NOW item fails THEN return to step 5. For a complete 0-100 compliance score, apply `references/15-scoring-algorithm.md` (every requirement maps to an automated probe or an explicit human-rubric input).

## Verify
> Why: Unverifiable standards are just opinions -- these checks are what turn "we follow established practices" into something a stranger can confirm.

- [ ] PASS: exactly one target was named before work started.
- [ ] PASS: `scripts/repo-audit.sh <repo-dir>` ran and every result is logged PASS/FAIL.
- [ ] PASS: NOW items were all fixed before any SOON item was touched.
- [ ] PASS: re-run of the audit shows every NOW item passing.
- [ ] PASS: every standard named in the output cites its name and source (e.g. "SemVer 2.0.0 -- semver.org").

## Guardrails
> Why: Each prohibition here has a real-world failure behind it -- a breached user, a hijacked install, a lawsuit -- not a desire for tidy rules.

- NEVER weaken a security standard to simplify: no skipping checksums, no `curl | sudo bash`, no blind shell-rc edits.
- NEVER recommend a standard on the roadmap's SKIP list for the project's size.
- NEVER invent standard names. Every claim about a standard MUST name the standard and its source.
- NEVER gold-plate: the smallest change that satisfies the standard is the change.

## Reference map

| File | Covers |
|---|---|
| `references/01-install-sh-fundamentals.md` | POSIX sh vs bash, strict mode, reference installer dissections |
| `references/02-install-sh-security.md` | Checksum/signature verification, TLS hardening, trust model |
| `references/03-install-sh-robustness.md` | Platform matrix, curl/wget fallback, retry, temp hygiene, idempotency |
| `references/04-install-sh-ux.md` | Progress bars, spinners, colors, PATH handling, messages |
| `references/05-install-sh-testing.md` | shellcheck, shfmt, bats, CI platform matrix |
| `references/06-repo-structure.md` | Root layout, workflows, licensing files, hygiene |
| `references/07-readme.md` | Section order, badges, installation section, tone |
| `references/08-versioning-releases.md` | SemVer, Conventional Commits, changelog, release automation |
| `references/09-licensing-compliance.md` | SPDX, OSI, REUSE, DCO vs CLA, attribution |
| `references/10-supply-chain-security.md` | SLSA, Sigstore/cosign, Scorecard, reproducible builds, SBOM |
| `references/11-security-process.md` | SECURITY.md, coordinated disclosure, CVE flow |
| `references/12-cicd.md` | Pipeline stages, provenance, SHA-pinned actions, least privilege |
| `references/13-docs-community.md` | Diataxis, ADRs, man pages, CoC, CONTRIBUTING, CODEOWNERS |
| `references/14-adoption-roadmap.md` | NOW / SOON / LATER / SKIP prioritization |
| `references/15-scoring-algorithm.md` | Standalone 0-100 compliance-scoring algorithm: bands, criteria, weights, gates, probes |
| `references/16-scoring-appendix.md` | Scoring-algorithm appendix: anti-patterns, pseudocode, worked example, pinned standard versions |

Read a reference only when its topic is in scope. Do not preload all of them.

## Scripts and assets

- `scripts/repo-audit.sh` -- POSIX-sh checklist auditor for a repo directory. Reports PASS/FAIL per standard; exit nonzero on any NOW-item failure.
- `assets/SECURITY-template.md` -- minimal SECURITY.md starter.
- `assets/install-sh-skeleton.sh` -- minimal installer skeleton with the standard idioms (strict mode, checksum, progress bar, trap cleanup).
