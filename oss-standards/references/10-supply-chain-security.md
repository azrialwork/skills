<!--
  10-supply-chain-security.md -- Reference for oss-standards.

  Covers: SLSA, Sigstore/cosign, OpenSSF Scorecard, reproducible builds,
  and SBOM. Read when hardening release integrity.
-->

# Supply-chain security

## Algorithm
> Why: Your release pipeline is a more valuable target than your code -- compromising it ships malware under your name to every user at once.

INPUT: the repo's release pipeline and release assets.

1. **SLSA v1.2 (slsa.dev/spec/v1.2).** For a tiny repo: run releases in GitHub Actions with GitHub Artifact Attestations (Sigstore-backed) -- ~10 lines of YAML gives approximately Build L2 provenance (approx Build L3 when the release runs inside a reusable workflow). Attach attestations to EVERY release. Track rules: Build track is L0-L3 (there is no Build L4): L1 = provenance exists; L2 = signed provenance from a hosted build; L3 = hardened platform, signing material inaccessible to build steps. Source track is L1-L4 (new in v1.2): L1 = version-controlled; L2 = history and provenance; L3 = continuous technical controls (branch protection, required checks/reviews enforced); L4 = two-party review. NEVER claim Source L4 for a solo-maintainer project -- it is unreachable by definition.
2. **Sigstore + cosign (docs.sigstore.dev).** Sign release files keyless: `cosign sign-blob --bundle artifact.sigstore.json`. Verify with `--certificate-identity` and `--certificate-oidc-issuer`. ALWAYS verify "signed by *whom*"; NEVER accept "is it signed" alone. (Components: Fulcio CA issuing short-lived OIDC-bound certs; Rekor append-only transparency log; cosign client. Adopters: Kubernetes, npm provenance, GitHub Artifact Attestations, uv via `gh attestation verify`.)
3. **OpenSSF Scorecard v5.5.0 (scorecard.dev).** Add the Scorecard workflow and display the badge. THEN fix the cheap zeros first, in this order: token permissions, dependency pinning, SECURITY.md, signed releases. (Checks scored 0-10 each; aggregate is the risk-weighted mean: Critical=10, High=7.5, Medium=5, Low=2.5; inconclusive checks excluded. Checked: Signed-Releases, Pinned-Dependencies, Token-Permissions, Branch-Protection, Code-Review, CI-Tests, Binary-Artifacts, License, Security-Policy, Dangerous-Workflow, Webhooks, Dependency-Update-Tool, Maintained, Contributors, Vulnerabilities, SAST, Fuzzing, Packaging, SBOM, CII-Best-Practices.)
4. **OpenSSF Best Practices badge (bestpractices.dev).** Self-certify at Passing tier minimum (Silver -> Gold as the project matures). The Scorecard `CII-Best-Practices` check reads it. A 2026 trust signal for the README.
5. **Reproducible builds (reproducible-builds.org).** IF pursuing THEN: pin the toolchain, set `SOURCE_DATE_EPOCH` from the tag commit, publish SHA256SUMS. Independent rebuilds then verify your release artifacts bit-for-bit.
6. **SBOM (NTIA minimum elements).** Generate with Syft; attach to the release. Format: IF strongest license metadata is the priority THEN SPDX 3.0.1 (current, Dec 2024). ELSE IF strongest vulnerability/VEX integration is the priority THEN CycloneDX 1.6 / 1.7 (1.7 = ECMA-424 2nd ed., Dec 2025). Note: ISO/IEC 5962:2021 transposes SPDX 2.2.1, not 2.3 -- anyone citing "SPDX is an ISO standard" is citing 2.2.1 (flagged for revision); SPDX 2.3 (Nov 2022) remains acceptable where tooling has not moved yet. EU Cyber Resilience Act (Regulation (EU) 2024/2847), Annex I Part II(1), requires manufacturers to document components "by drawing up a software bill of materials in a commonly used and machine-readable format covering at the very least the top-level dependencies" -- applies 11 Dec 2027 (reporting duties under Art. 14 apply from 11 Sep 2026). Pure open-source software supplied outside a commercial activity is out of scope.

## Priority order for a small project (strict)
> Why: Doing supply-chain security out of order produces theater -- a signed SBOM on a release with no checksum proves nothing about what was actually shipped.

Apply in this order; NEVER start a later item while an earlier one is missing:

1. SHA256SUMS on every release (NOW).
2. GitHub Artifact Attestations / SLSA provenance (SOON).
3. Scorecard workflow + badge (SOON).
4. SBOM per release (LATER).
5. Reproducible builds (LATER).
