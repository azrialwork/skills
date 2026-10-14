<!--
  03-install-sh-robustness.md -- Reference for oss-standards.

  Covers: platform detection, download fallbacks, retry, temp hygiene,
  idempotency, and CLI flags. Read when making an installer robust.
-->

# install.sh robustness

## Algorithm

INPUT: the installer script.

1. **Platform detection.** Normalize with a `case $(uname -sm)` matrix covering `aarch64|arm64` and `x86_64|x64` plus OS (`Linux`, `Darwin`). IF `uname -o` returns `Android` THEN apply the Termux/musl path (oh-my-zsh detects Termux via `case "$PREFIX" in *com.termux*)`; mise maps Android to its musl variant). IF libc flavor matters THEN probe it (`ldd /bin/ls | grep musl`, `/etc/alpine-release`, or glibc-version check with musl fallback). IF the platform is unsupported THEN fail with a clear message; NEVER silently install the wrong binary.
2. **Download resilience.** Use curl first, wget as fallback (mise, nvm translate flags between them). Add retry: `--retry 5` (flyctl) or exponential backoff (Homebrew). Resume partial downloads with `curl -C -` where appropriate. Do not fight proxies: curl honors `https_proxy`/`HTTPS_PROXY` automatically.
3. **Temp hygiene.** Create with `tmpdir=$(mktemp -d)` and trap cleanup: `trap 'rm -rf "$tmpdir"' EXIT INT TERM`. Quote EVERY `rm -rf "$var"`; an unquoted `rm -rf $var` is a FAIL. Warn when /tmp is mounted noexec (rustup pattern).
4. **Idempotency.** Re-running MUST be safe: IF the installed version already matches THEN skip (mise: `MISE_INSTALL_SKIP_IF_EXISTS=1`); ELSE upgrade cleanly in place. Install atomically: extract to the temp dir, `chmod +x`, then `mv` into place -- NEVER write over a running executable (flyctl pattern).
5. **CLI surface.** `--help` and `--version` are mandatory. IF stdin is not a tty THEN run non-interactive automatically (oh-my-zsh pattern); also accept `--yes` / `NONINTERACTIVE=1`. Support version pinning via env var (`MISE_VERSION`, `TOOL_VERSION`) or positional arg (deno). IF the installer does anything destructive THEN implement a true `--dry-run`.

## FLAG on sight (FAIL)

- `rm -rf` with unquoted or unguarded variables.
- Hardcoded `/usr/local` (breaks Termux, containers, unprivileged users).
- Assuming sudo exists or is needed.
- Silent failure on unsupported arch (installs x86_64 binary on aarch64).
