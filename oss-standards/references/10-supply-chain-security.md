<!--
  10-supply-chain-security.md -- Reference for oss-standards.

  Covers: SLSA, Sigstore/cosign, OpenSSF Scorecard, reproducible builds,
  and SBOM. Read when hardening release integrity.
-->

# Supply-chain security

## SLSA (slsa.dev)

- Framework for build integrity. SLSA v1.0 restructured levels into
  tracks; the **Build track is L1-L3** (there is no Build L4).
- **For a tiny repo:** GitHub Actions + GitHub Artifact Attestations
  (Sigstore-backed) gives approximately Build L2/L3 provenance with
  about 10 lines of YAML. Attach attestations to every release.

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

## OpenSSF Scorecard (scorecard.dev)

- Automated security-posture scanner (0-10 per check): Signed-Releases,
  Pinned-Dependencies, Token-Permissions, Branch-Protection,
  Code-Review, CI-Tests, Binary-Artifacts, License, Security-Policy.
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
- Formats: **SPDX 2.3** (ISO/IEC 5962:2021; strongest license metadata)
  and **CycloneDX 1.5/1.6** (OWASP, ECMA-424; strongest
  vulnerability/VEX integration). Generate with Syft; attach to the
  release. EU Cyber Resilience Act Art. 13(25) requires SBOMs in a
  commonly used machine-readable format.

## Priority order for a small project

1. SHA256SUMS on every release (NOW).
2. GitHub Artifact Attestations / SLSA provenance (SOON).
3. Scorecard workflow + badge (SOON).
4. SBOM per release (LATER).
5. Reproducible builds (LATER).
