<!--
  03-install-sh-robustness.md -- Reference for oss-standards.

  Covers: platform detection, download fallbacks, retry, temp hygiene,
  idempotency, and CLI flags. Read when making an installer robust.
-->

# install.sh robustness

## Platform detection

- Normalize with a `case $(uname -sm)` matrix: `aarch64|arm64`,
  `x86_64|x64`, plus OS (`Linux`, `Darwin`).
- **Android/Termux:** `uname -o` returns `Android`; oh-my-zsh detects
  Termux via `case "$PREFIX" in *com.termux*)`. mise maps Android to its
  musl variant explicitly.
- Probe libc flavor when it matters: `ldd /bin/ls | grep musl`, or check
  `/etc/alpine-release` (rustup); uv checks the glibc version and falls
  back to musl.
- Fail with a clear message on unsupported platforms; never silently
  install the wrong binary.

## Download resilience

- **curl first, wget fallback** (mise, nvm translate flags between them).
- **Retry:** `--retry 5` (flyctl) or exponential backoff (Homebrew).
  Resume partial downloads with `curl -C -` where appropriate.
- **Proxy support:** curl honors `https_proxy`/`HTTPS_PROXY` automatically;
  do not fight it.

## Temp hygiene

- `tmpdir=$(mktemp -d)` and `trap 'rm -rf "$tmpdir"' EXIT INT TERM`.
- Quote every `rm -rf "$var"`; never `rm -rf $var` unquoted.
- rustup warns when /tmp is mounted noexec.

## Idempotency

- Re-running the installer must be safe: skip when the installed version
  already matches (mise: `MISE_INSTALL_SKIP_IF_EXISTS=1`), or cleanly
  upgrade in place.
- **Atomic install:** extract to the temp dir, `chmod +x`, then `mv` into
  place -- never write over a running executable (flyctl).

## CLI surface

- `--help` and `--version` are mandatory.
- Non-interactive mode: `--yes` / `NONINTERACTIVE=1`; auto-unattended when
  stdin is not a tty (oh-my-zsh).
- Version pinning: env var (`MISE_VERSION`, `TOOL_VERSION`) or positional
  arg (deno).
- A true `--dry-run` is recommended by best practice but rare in the wild;
  implement it if the installer does anything destructive.

## Anti-patterns

- `rm -rf` with unquoted or unguarded variables.
- Hardcoding `/usr/local` (breaks Termux, containers, unprivileged users).
- Assuming sudo exists or is needed.
- Silent failure on unsupported arch (installs x86_64 binary on aarch64).
