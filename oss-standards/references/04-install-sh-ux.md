<!--
  04-install-sh-ux.md -- Reference for oss-standards.

  Covers: progress feedback, spinners, colors, PATH handling, and success /
  failure messages. Read when designing installer UX.
-->

# install.sh user experience

## Algorithm
> Why: Users decide in the first thirty seconds whether they trust your tool, and most of that judgment comes from what the installer shows them, not what it installs.

INPUT: the installer script's user-facing output.

1. **Progress feedback.** Use `curl -#fLo` (mise) or `curl --progress-bar` (deno, flyctl) for downloads -- it is the industry standard: free, honest, works everywhere. Print one log line per step (`=>` lines like nvm, `ohai`/`warn` like Homebrew, `info()`/`warn()` to stderr like mise); a silent step looks hung. IF a spinner is used THEN it MUST be TTY-gated with a plain-text fallback and `NO_COLOR` support; NEVER spin when output is piped. Support `MISE_QUIET=1` (silence info) and `MISE_DEBUG=1` (debug lines).
2. **Colors.** IF colors are emitted THEN gate them on `[ -t 2 ]` and `$TERM` (rustup pattern) AND respect `NO_COLOR`. NEVER emit color codes into pipes or log files.
3. **PATH handling.** NEVER blind-edit rc files. Select the first applicable method, in this order:
   1. IF the user can act THEN print "Next steps" and stop (Homebrew prints `eval "$(.../brew shellenv)"` per detected shell).
   2. ELSE IF drop-in dirs exist THEN write `~/.bashrc.d/` / `~/.zshrc.d/` files (flyctl): ask first via `/dev/tty`; IF non-interactive THEN print manual steps instead.
   3. ELSE IF an env-file fits THEN write `$HOME/.local/bin/env` and tell the user to source it from their rc file (uv pattern).
   4. ELSE append to the rc file directly ONLY with grep-before-append idempotency (nvm) AND an opt-out (`PROFILE=/dev/null`).
4. **Messages.** On success, print `"tool: installed successfully to $install_path"` PLUS the exact next command to run (flyctl: "Run 'flyctl --help' to get started"). On failure, state what failed, what was tried, and the next step (flyctl prints `%{http_code} %{url_effective}` on download failure). EVERY error MUST exit nonzero with the failing step named.

## FLAG on sight (FAIL)
> Why: Blindly editing someone's shell config is the fastest way to turn a first-time user into a permanent detractor.

- Editing `~/.bashrc` blindly with no idempotency check.
- Spinner or colors when piped / non-tty.
- Silent success (user cannot tell it worked) or silent failure.
