<!--
  09-licensing-compliance.md -- Reference for oss-standards.

  Covers: SPDX identifiers, OSI licenses, REUSE, DCO vs CLA, and
  attribution. Read when choosing or auditing a license setup.
-->

# Licensing and compliance

## Algorithm
> Why: Licensing is the only part of your project a company's lawyers read, and they read it before anyone is allowed to touch the code.

INPUT: the repo's license files, README, and contributor setup.

1. **Declare one OSI-approved license three ways:** (1) full text in `LICENSE` at root, (2) SPDX short identifier in README badges and package metadata, (3) `SPDX-License-Identifier:` in file headers where practical. IF the license is not on the OSI list (opensource.org/licenses) THEN do not invent a custom license -- pick an approved one.
2. **SPDX identifiers and expressions (spdx.org/licenses).** Use short IDs (`MIT`, `Apache-2.0`, `GPL-3.0-only`, ...). IF combining THEN use valid expressions: `Apache-2.0 OR MIT`, `GPL-2.0-only WITH Classpath-exception-2.0` (operator precedence: `+` > `WITH` > `AND` > `OR`).
3. **FSFE REUSE 3.3 (reuse.software/spec-3.3).** IF file count or corporate adoption makes per-file licensing matter (roadmap LATER) THEN make every file's licensing machine-readable: license texts in `LICENSES/<SPDX-ID>.txt`, per-file `SPDX-License-Identifier` headers or `.license` sidecars, `REUSE.toml` for exceptions (since 3.3, `REUSE.toml` itself needs no licensing header; `LICENSE`/`COPYING` may carry a `-<suffix>` like `LICENSE-MIT`). Enforce with `reuse lint` in CI. ELSE skip REUSE for now.
4. **DCO vs CLA.** IF any contributor agreement is needed THEN default to DCO (Developer Certificate of Origin): per-commit attestation (`Signed-off-by: Name <email>`, `git commit -s`); contributor keeps copyright; inbound = outbound license. Low friction; the Linux/CNCF standard. Adopt CLA (signed contract, e.g. via cla-assistant) ONLY IF you foresee relicensing or dual-licensing. For most small projects: SKIP both.
5. **Attribution.** IF the license is Apache-2.0 THEN section 4(d) requires preserving `NOTICE` attributions in redistributions. Practice: ship `NOTICE`, `THIRD_PARTY`, or `THIRD-PARTY-NOTICES` listing bundled dependencies with their licenses.

## FLAG on sight (FAIL)
> Why: A project with no license file is not open source -- it is proprietary by default, and corporate users are forbidden from touching it.

- No LICENSE file (project is legally unusable).
- Custom "do what you want" license text instead of an OSI-approved one.
- Vendored dependencies with no attribution.
