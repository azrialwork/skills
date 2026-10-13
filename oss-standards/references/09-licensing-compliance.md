<!--
  09-licensing-compliance.md -- Reference for oss-standards.

  Covers: SPDX identifiers, OSI licenses, REUSE, DCO vs CLA, and
  attribution. Read when choosing or auditing a license setup.
-->

# Licensing and compliance

## The license itself

- **One OSI-approved license**, declared three ways: (1) full text in
  `LICENSE` at root, (2) SPDX short identifier in README badges and
  package metadata, (3) `SPDX-License-Identifier:` in file headers
  where practical.
- If it is not on the OSI list (opensource.org/licenses), do not invent
  a custom license -- pick an approved one.

## SPDX identifiers and expressions (spdx.org/licenses)

- Short IDs: `MIT`, `Apache-2.0`, `GPL-3.0-only`, ...
- Expressions: `Apache-2.0 OR MIT`,
  `GPL-2.0-only WITH Classpath-exception-2.0` (`AND` / `OR` / `WITH`).

## FSFE REUSE 3.3 (reuse.software/spec-3.3)

- Every file's licensing must be machine-readable: license texts in
  `LICENSES/<SPDX-ID>.txt`, per-file `SPDX-License-Identifier` headers
  or `.license` sidecars, `REUSE.toml` for exceptions. (Since 3.3:
  `REUSE.toml` itself needs no licensing header; `LICENSE`/`COPYING`
  may carry a `-`/`-`suffix like `LICENSE-MIT`.)
- Enforce with `reuse lint` in CI. Adopt when file count or corporate
  adoption makes per-file licensing matter (roadmap LATER).

## DCO vs CLA

- **DCO (Developer Certificate of Origin):** per-commit attestation
  (`Signed-off-by: Name <email>`, `git commit -s`); contributor keeps
  copyright; inbound = outbound license. Low friction; the Linux/CNCF
  standard. Right for a tiny repo, if anything.
- **CLA (Contributor License Agreement):** signed contract (e.g. via
  cla-assistant); can grant relicensing rights and patent grants.
  Higher friction; adopt only if you foresee relicensing or
  dual-licensing. For most small projects: SKIP.

## Attribution

- Apache-2.0 section 4(d) requires preserving `NOTICE` attributions in
  redistributions. Practice: `NOTICE`, `THIRD_PARTY`, or
  `THIRD-PARTY-NOTICES` listing bundled dependencies with their licenses.

## Anti-patterns

- No LICENSE file (project is legally unusable).
- Custom "do what you want" license text instead of an OSI-approved one.
- Vendored dependencies with no attribution.
