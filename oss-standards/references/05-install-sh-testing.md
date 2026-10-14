<!--
  05-install-sh-testing.md -- Reference for oss-standards.

  Covers: static analysis and runtime testing for installer scripts.
  Read when setting up installer CI.
-->

# install.sh testing

## Algorithm

INPUT: the installer script and its CI workflow.

1. **Static analysis (the professional floor).** Run ALL three; IF any fails THEN the PR is blocked:
   - `shellcheck install.sh` exit 0 (ship a `.shellcheckrc`; add `# shellcheck shell=dash` directives where the dialect matters).
   - `shfmt -d install.sh` zero diff.
   - `sh -n install.sh` syntax check (the cheapest gate).
2. **Runtime tests.** Write bats (or shunit2) tests covering: platform detection, checksum verification with a GOOD checksum, checksum verification with a BAD checksum (MUST fail), and an idempotent re-run. IF a test covers only the happy path THEN add the failure cases.
3. **Distro matrix.** Run the installer on docker containers for ubuntu, debian, alpine, and fedora at minimum. IF Android is a target THEN add a Termux-ish check (busybox `tar` and `mksh`-derived `sh` behave differently). The installer MUST succeed end to end on every matrix entry.
4. **CI shape.** Every PR runs: shellcheck, `shfmt -d`, `sh -n`, bats. A matrix job runs `docker run <distro> ./install.sh && tool --version`. mise's pattern (jdx/mise#10882): the installer is generated from a template and shellcheck-tested AFTER rendering.

## FLAG on sight (FAIL)

- Shipping an installer that was only ever run on the author's machine.
- Testing only the happy path (no bad-checksum, no retry, no re-run).
- `curl | sh` in CI without pinning what is being installed.
