<!--
  SECURITY.md -- Security policy for the skills collection.

  Purpose: tells security researchers how to report vulnerabilities
  privately. The skills ship executable scripts, so a private channel
  is warranted.
-->

# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| latest `main` | :white_check_mark: |

## Reporting a Vulnerability

**Do not open a public issue.** The skills in this repo ship executable
scripts (`scripts/`) that agents run, so script-injection or
prompt-injection flaws matter.

Report privately via:

- GitHub: `https://github.com/azrialwork/skills/security/advisories/new`

We aim to acknowledge reports within 48 hours. Fixes are released as
commits on `main` together with a coordinated public advisory.
