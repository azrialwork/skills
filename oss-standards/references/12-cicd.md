<!--
  12-cicd.md -- Reference for oss-standards.

  Covers: pipeline stages, artifact provenance, SHA-pinned actions, and
  least-privilege tokens. Read when writing or hardening workflows.
-->

# CI/CD standards

## Standard pipeline stages

**lint -> test -> build -> sign -> publish.** For a single-binary repo:

1. `lint` -- shellcheck, shfmt, and the source language's formatter.
2. `test` -- unit tests + installer smoke tests (see
   `05-install-sh-testing.md`).
3. `build` -- matrix over target platforms; pinned toolchain.
4. `sign` -- SHA256SUMS + Sigstore/cosign or GitHub Artifact
   Attestations + SLSA provenance.
5. `publish` -- draft GitHub Release on tag; attach artifacts. Only the
   release workflow gets `contents: write`.

## Artifact provenance

Every release artifact must be traceable to a commit + workflow run:
SLSA provenance or GitHub attestations attached to the release
(Scorecard `Signed-Releases` checks this).

## Pin third-party actions to SHAs

- **Pin every third-party action to a full 40-char commit SHA**, with
  the tag as a trailing comment:
  `actions/checkout@<sha> # v5.0.0`.
- Let Dependabot bump SHAs via reviewed PRs (Scorecard
  `Pinned-Dependencies` and `Dependency-Update-Tool`).

## Minimal permissions (least privilege)

- Top-level `permissions: contents: read` on **every** workflow.
- Elevate per-job only where needed: `contents: write` for the release
  job, `id-token: write` for Sigstore/OIDC, `security-events: write`
  for CodeQL/Scorecard uploads.
- Scorecard `Token-Permissions` fails workflows with broad defaults.

## Anti-patterns

- `permissions: write-all` or no permissions block (broad token).
- Floating action tags (`actions/checkout@v4`) on the release pipeline.
- Hand-attached release artifacts built outside CI.
- Secrets printed to logs; `pull_request_target` without pinned review.
