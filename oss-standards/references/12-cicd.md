<!--
  12-cicd.md -- Reference for oss-standards.

  Covers: pipeline stages, artifact provenance, SHA-pinned actions, and
  least-privilege tokens. Read when writing or hardening workflows.
-->

# CI/CD standards

## Algorithm

INPUT: the repo's `.github/workflows/` directory.

1. **Build the standard pipeline: lint -> test -> build -> sign -> publish.** For a single-binary repo the stages are:
   1. `lint` -- shellcheck, shfmt, and the source language's formatter.
   2. `test` -- unit tests + installer smoke tests (see `05-install-sh-testing.md`).
   3. `build` -- matrix over target platforms; pinned toolchain.
   4. `sign` -- SHA256SUMS + Sigstore/cosign or GitHub Artifact Attestations + SLSA provenance.
   5. `publish` -- draft GitHub Release on tag; attach artifacts. ONLY the release workflow gets `contents: write`.
2. **Guarantee artifact provenance.** EVERY release artifact MUST be traceable to a commit + workflow run: attach SLSA provenance or GitHub attestations to the release (Scorecard `Signed-Releases` checks this).
3. **Pin third-party actions to SHAs.** EVERY third-party `uses:` MUST be a full 40-char commit SHA with the tag as a trailing comment: `actions/checkout@<sha> # v5.0.0`. Let Dependabot bump SHAs via reviewed PRs (Scorecard `Pinned-Dependencies` and `Dependency-Update-Tool`).
4. **Apply least privilege.** EVERY workflow MUST declare top-level `permissions: contents: read`. Elevate per-job ONLY where needed: `contents: write` for the release job, `id-token: write` for Sigstore/OIDC, `security-events: write` for CodeQL/Scorecard uploads. IF a workflow has broad default permissions THEN Scorecard `Token-Permissions` fails it: FAIL.

## FLAG on sight (FAIL)

- `permissions: write-all` or no permissions block (broad token).
- Floating action tags (`actions/checkout@v4`) on the release pipeline.
- Hand-attached release artifacts built outside CI.
- Secrets printed to logs; `pull_request_target` without pinned review.
