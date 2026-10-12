<!--
  05-install-sh-testing.md -- Reference for oss-standards.

  Covers: static analysis and runtime testing for installer scripts.
  Read when setting up installer CI.
-->

# install.sh testing

## Static analysis (the professional floor)

- **shellcheck** on every installer script, enforced in CI. Ship a
  `.shellcheckrc` (mise does) and add `# shellcheck shell=dash`
  directives where the dialect matters.
- **shfmt** for formatting (`shfmt -d` zero-diff check in CI).
- `sh -n script.sh` syntax check as the cheapest gate.

## Runtime testing

- **bats** (or shunit2) for installer logic: platform detection,
  checksum verification (good and bad checksums), idempotent re-runs.
- **Docker distro matrix:** run the installer on ubuntu, debian, alpine,
  and fedora containers at minimum; add a Termux-ish check when Android
  is a target (busybox `tar` and `mksh`-derived `sh` behave differently).
- mise shellcheck-tests its install.sh in CI (jdx/mise#10882 pattern):
  the installer is generated from a template and tested after rendering.

## CI shape

```yaml
# every PR: lint + format + smoke test
- shellcheck install.sh
- shfmt -d install.sh
- sh -n install.sh
- bats tests/install.bats
# matrix job: docker run <distro> ./install.sh && tool --version
```

## Anti-patterns

- Shipping an installer that was only ever run on the author's machine.
- Testing only the happy path (no bad-checksum, no retry, no re-run).
- `curl | sh` in CI without pinning what is being installed.
