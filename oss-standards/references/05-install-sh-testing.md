<!--
  05-install-sh-testing.md -- Reference for oss-standards.

  Covers: static analysis and runtime testing for installer scripts.
  Read when setting up installer CI.
-->

# install.sh testing

## Algorithm
> Why: The author's machine is the one environment the installer was never going to fail in -- shipping without independent verification makes a stranger your first tester.

INPUT: the installer script and its CI workflow.

1. **Static analysis (the professional floor).** Run ALL three; IF any fails THEN the PR is blocked:
   - `shellcheck install.sh` exit 0 (ship a `.shellcheckrc`; add `# shellcheck shell=dash` directives where the dialect matters).
   - `shfmt -d install.sh` zero diff.
   - `sh -n install.sh` syntax check (the cheapest gate).
2. **Runtime tests.** Write bats (or shunit2) tests covering: platform detection, checksum verification with a GOOD checksum, checksum verification with a BAD checksum (MUST fail), and an idempotent re-run. IF a test covers only the happy path THEN add the failure cases.
3. **Platform matrix.** Run the installer on containers covering the project's supported platform matrix at minimum: at least one glibc-based Linux, one musl-based Linux, and one minimal POSIX environment (busybox-style `tar` and a minimal `sh` behave differently from their full-featured counterparts). The installer MUST succeed end to end on every matrix entry.
4. **CI shape.** Every PR runs: shellcheck, `shfmt -d`, `sh -n`, bats. A matrix job runs `docker run <image> ./install.sh && tool --version`. mise's pattern (jdx/mise#10882): the installer is generated from a template and shellcheck-tested AFTER rendering.

## FLAG on sight (FAIL)
> Why: Happy-path-only tests pass on the day you write them and fail on the day a user depends on them.

- Shipping an installer that was only ever run on the author's machine.
- Testing only the happy path (no bad-checksum, no retry, no re-run).
- `curl | sh` in CI without pinning what is being installed.
