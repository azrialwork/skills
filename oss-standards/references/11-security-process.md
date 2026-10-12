<!--
  11-security-process.md -- Reference for oss-standards.

  Covers: SECURITY.md contents, coordinated disclosure, CVE flow, and
  GitHub private vulnerability reporting. Read when setting up the
  security process.
-->

# Security process

## SECURITY.md standard contents

A 15-line SECURITY.md is enough for a small project:

1. **Supported versions** table (which releases get security fixes).
2. **Private reporting channel:** GitHub private vulnerability reporting
   link and/or a `security@` email. Never "open a public issue".
3. **What to expect:** acknowledgment timeline, triage process, and how
   fixes are released.
4. **Scope notes** (what is in scope for reports), optional for tiny repos.

See `assets/SECURITY-template.md` for a starter.

## Coordinated vulnerability disclosure

- Flow: private report -> acknowledge -> triage -> fix ->
  **coordinated public disclosure** (advisory + patched release
  published simultaneously).
- Embargo norm: 90 days (popularized by Google Project Zero);
  negotiate with the reporter, do not surprise them.

## CVE assignment flow

- Request via a **CVE Numbering Authority (CNA)**; MITRE is the root.
- For a small project: GitHub Security Advisory -> "Request CVE"
  (GitHub is a CNA). No separate MITRE request needed.

## GitHub private vulnerability reporting

- Enable in repo Settings -> Security. Reporters use
  `/security/advisories/new`: creates a private advisory visible only
  to maintainers and the reporter, with a built-in fix/PR workflow and
  credit on publish.

## Anti-patterns

- "Report security issues via public GitHub issues."
- No SECURITY.md (Scorecard `Security-Policy` check fails; researchers
  have no private channel).
- Silent fixes with no advisory (users cannot assess their exposure).
