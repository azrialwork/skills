<!--
  04-install-sh-ux.md -- Reference for oss-standards.

  Covers: progress feedback, spinners, colors, PATH handling, and success /
  failure messages. Read when designing installer UX.
-->

# install.sh user experience

## Progress feedback

- **Download progress bar is the industry standard:** `curl -#fLo`
  (mise) or `curl --progress-bar` (deno, flyctl). It is free, honest,
  and works everywhere.
- **Spinners are NOT the industry standard.** Top-tier installers use
  per-step log lines plus curl's progress bar. A spinner is acceptable
  only when TTY-gated with a plain-text fallback and `NO_COLOR` support;
  never spin when output is piped.
- **Per-step log lines:** nvm's `=>` lines, Homebrew's `ohai`/`warn`,
  mise's `info()`/`warn()` to stderr. One line per step; silent steps
  look hung.
- Env-var knobs: `MISE_QUIET=1` silences info, `MISE_DEBUG=1` enables
  debug lines.

## Colors

- Gate colors on `[ -t 2 ]` and `$TERM` (rustup); respect `NO_COLOR`.
- Never emit color codes into pipes or log files.

## PATH handling (never blind-edit rc files)

Ranked from best to worst, per the dissections:

1. **Print "Next steps"** and let the user act (Homebrew: prints
   `eval "$(.../brew shellenv)"` per detected shell).
2. **Drop-in files** in `~/.bashrc.d/` / `~/.zshrc.d/` (flyctl) -- asks
   first via `/dev/tty`, prints manual steps when non-interactive.
3. **Env-file pattern:** write `$HOME/.local/bin/env`, tell the user to
   source it from their rc file (uv).
4. Direct rc-file append -- only with grep-before-append idempotency
   (nvm) and an opt-out (`PROFILE=/dev/null`).

## Messages

- Success: `"tool: installed successfully to $install_path"` + the exact
  next command to run (flyctl: "Run 'flyctl --help' to get started").
- Failure: state what failed, what was tried, and the next step
  (flyctl prints `%{http_code} %{url_effective}` on download failure).
- Every error exits nonzero with the failing step named.

## Anti-patterns

- Editing `~/.bashrc` blindly with no idempotency check.
- Spinner or colors when piped / non-tty.
- Silent success (user cannot tell it worked) or silent failure.
