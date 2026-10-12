<!--
  pull-request-template.md -- Asset for git-workflow.

  Purpose: PR template answering what changed, why, and how it was
  tested. Copy to .github/pull-request-template.md to enable.
-->

## What

<!-- One paragraph: what changed in this PR. -->

## Why

<!-- Why is this change needed? Link the issue if there is one. -->

## How it was tested

<!-- Commands run and their results. -->
- [ ] `scripts/commit-lint.sh` passes on the commit messages
- [ ] CI is green
- [ ] Manual verification: <!-- describe what was checked -->

## Checklist

- [ ] Conventional Commits format on every commit
- [ ] No secrets committed (`.env`, keys, tokens)
- [ ] Docs updated if behavior changed
