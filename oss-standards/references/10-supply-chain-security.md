<!--
  10-supply-chain-security.md -- Reference for oss-standards.

  Covers: SLSA, Sigstore/cosign, OpenSSF Scorecard, reproducible builds,
  and SBOM. Read when hardening release integrity.
-->

# Supply-chain security

## SLSA v1.2 (slsa.dev/spec/v1.2)

- Framework for build integrity, organized in **tracks** (an artifact
  holds one level per track, e.g. "Build L2, Source L1").
- **Build track L0-L3** (finalized; there is no Build L4): L1 =
  provenance exists; L2 = signed provenance from a hosted build; L3 =
  hardened platform, signing material inaccessible to build steps.
- **Source track L1-L4** (new in v1.2): L1 = version-controlled; L2 =
  history and provenance; L3 = continuous technical controls
  (branch protection, required checks/reviews enforced); L4 =
  two-party review. Note: Source L4 is unreachable for a
  solo-maintainer project by definition -- do not claim it.
- **For a tiny repo:** GitHub Actions + GitHub Artifact Attestations
  (Sigstore-backed) gives approximately Build L2 provenance with about
  10 lines of YAML (approx Build L3 when the release runs inside a
  reusable workflow). Attach attestations to every release. Branch
  protection + required PR reviews are your Source-track controls.

## Sigstore + cosign (docs.sigstore.dev)

- Linux Foundation project: **Fulcio** (CA issuing short-lived certs
  bound to OIDC identity), **Rekor** (append-only transparency log),
  **cosign** (signing client). Keyless signing -- no long-lived keys.
- Practice: `cosign sign-blob --bundle artifact.sigstore.json` for
  release files; verify with `--certificate-identity` and
  `--certificate-oidc-issuer`. Always verify "signed by *whom*",
  never just "is it signed".
- Adopters: Kubernetes, npm provenance, GitHub Artifact Attestations,
  uv (`gh attestation verify`).

## OpenSSF Scorecard v5.5.0 (scorecard.dev)

- Automated security-posture scanner (0-10 per check; aggregate is the
  risk-weighted mean: Critical=10, High=7.5, Medium=5, Low=2.5;
  inconclusive checks are excluded). Checks: Signed-Releases,
  Pinned-Dependencies, Token-Permissions, Branch-Protection,
  Code-Review, CI-Tests, Binary-Artifacts, License, Security-Policy,
  Dangerous-Workflow, Webhooks, Dependency-Update-Tool, Maintained,
  Contributors, Vulnerabilities, SAST, Fuzzing, Packaging, SBOM,
  CII-Best-Practices.
- Practice: add the Scorecard workflow, display the badge, fix the
  cheap zeros first (token permissions, pinning, SECURITY.md, signed
  releases).

## OpenSSF Best Practices badge (bestpractices.dev)

- Self-certification, tiers Passing -> Silver -> Gold. The Scorecard
  `CII-Best-Practices` check reads it. A 2026 trust signal for the README.

## Reproducible builds (reproducible-builds.org)

- Definition: given the same source, build environment, and build
  instructions, any party can recreate bit-for-bit identical artifacts.
- For a single-binary repo: pin the toolchain, set `SOURCE_DATE_EPOCH`
  from the tag commit, publish SHA256SUMS. Independent rebuilds then
  verify your release artifacts.

## SBOM (NTIA minimum elements)

- US NTIA defines 7 minimum fields: supplier name, component name,
  component version, unique identifiers (PURL/CPE), dependency
  relationship, SBOM author, timestamp.
- Formats: **SPDX 3.0.1** (current, Dec 2024; strongest license
  metadata) and **CycloneDX 1.6 / 1.7** (1.7 = ECMA-424 2nd ed., Dec 2025;
  strongest vulnerability/VEX integration; 1.5 and earlier are legacy).
  Note: ISO/IEC 5962:2021 transposes **SPDX 2.2.1**, not 2.3 -- anyone
  citing "SPDX is an ISO standard" is citing 2.2.1 (flagged for
  revision); SPDX 2.3 (Nov 2022) remains widely deployed and acceptable
  where tooling has not moved yet.
- Generate with Syft; attach to the release. EU Cyber Resilience Act
  (Regulation (EU) 2024/2847), **Annex I, Part II(1)**, requires
  manufacturers to document components "by drawing up a software bill
  of materials in a commonly used and machine-readable format covering
  at the very least the top-level dependencies" -- applies
  **11 Dec 2027** (reporting duties under Art. 14 apply from
  11 Sep 2026). Pure open-source software supplied outside a commercial
  activity is out of scope.

## Priority order for a small project

1. SHA256SUMS on every release (NOW).
2. GitHub Artifact Attestations / SLSA provenance (SOON).
3. Scorecard workflow + badge (SOON).
4. SBOM per release (LATER).
5. Reproducible builds (LATER).
