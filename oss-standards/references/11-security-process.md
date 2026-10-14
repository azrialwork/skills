<!--
  11-security-process.md -- Reference for oss-standards.

  Covers: SECURITY.md contents, coordinated disclosure, CVE flow, and
  GitHub private vulnerability reporting. Read when setting up the
  security process.
-->

# Security process

## Algorithm

INPUT: the repo (new or existing).

1. **Write SECURITY.md (15 lines is enough for a small project).** It MUST contain: (1) a supported-versions table (which releases get security fixes); (2) a private reporting channel -- GitHub private vulnerability reporting link and/or a `security@` email; NEVER "open a public issue"; (3) what to expect: acknowledgment timeline, triage process, how fixes are released; (4) scope notes (optional for tiny repos). Start from `assets/SECURITY-template.md`.
2. **Enable GitHub private vulnerability reporting** in repo Settings -> Security. Reporters use `/security/advisories/new`: this creates a private advisory visible ONLY to maintainers and the reporter, with a built-in fix/PR workflow and credit on publish.
3. **Run coordinated disclosure.** On receiving a report: private report -> acknowledge -> triage -> fix -> coordinated public disclosure (advisory + patched release published SIMULTANEOUSLY). Embargo norm: 90 days (popularized by Google Project Zero); negotiate the timeline with the reporter; NEVER surprise them.
4. **Assign a CVE.** Request via a CVE Numbering Authority (CNA); MITRE is the root. IF the project is small THEN use GitHub Security Advisory -> "Request CVE" (GitHub is a CNA); no separate MITRE request needed.

## FLAG on sight (FAIL)

- "Report security issues via public GitHub issues."
- No SECURITY.md (Scorecard `Security-Policy` check fails; researchers have no private channel).
- Silent fixes with no advisory (users cannot assess their exposure).
