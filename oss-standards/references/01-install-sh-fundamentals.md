<!--
  01-install-sh-fundamentals.md -- Reference for oss-standards.

  Covers: POSIX sh vs bash choice, strict-mode idioms, and dissections of
  eight professional installer scripts. Read when writing or reviewing a
  curl|bash installer.
-->

# install.sh fundamentals

## Shell choice

- **Default to POSIX `sh` (`#!/bin/sh`)** for piped installers. `/bin/sh`
  exists on every Unix (Termux ships `sh`; minimal containers ship dash).
  rustup, oh-my-zsh, mise, Deno, flyctl, and uv all use `#!/bin/sh`.
- **Use bash only when you genuinely need bash features**, then enforce it:
  nvm uses `#!/usr/bin/env bash` (relies on bash throughout); Homebrew uses
  `#!/bin/bash` and hard-errors on other shells.

## Strict mode

- **POSIX sh:** `set -eu` (mise uses exactly this; uv uses `set -u`).
  POSIX sh has **no `pipefail`** -- compensate with explicit checks like
  rustup's `ensure` / `need_cmd` / `assert_nz` wrappers
  (e.g. `ensure curl "$url" -o "$file"` catches a failed download).
- **Bash:** `set -euo pipefail`.
- `set -u` catches typo'd variable names (the #1 installer bug source);
  `set -e` turns silent corruption into a loud early exit.

## Reference implementations (dissected 2026-10-12)

| Script | Dialect | Notable idioms |
|---|---|---|
| rustup-init.sh | `#!/bin/sh`, `set -u` | TLS hardening `--proto '=https' --tlsv1.2`; `need_tty` reconnects piped stdin to `/dev/tty`; Android maps to `linux-android`; warns on noexec /tmp |
| nvm install.sh | `#!/usr/bin/env bash` | Whole script wrapped in `{ }` as a partial-download guard; idempotent profile append (grep-before-append); `=>` step lines |
| oh-my-zsh install.sh | `#!/bin/sh`, `set -e` | **Termux detection** via `case "$PREFIX" in *com.termux*)`; never destroys `.zshrc` (renames to `.zshrc.pre-oh-my-zsh`); documents "Manual Inspection" (download, inspect, run) |
| Homebrew install.sh | `#!/bin/bash`, `set -u` | Aborts on root; `retry` with exponential backoff; `ohai`/`warn`/`execute` helpers; **never edits rc files -- prints "Next steps"** |
| mise (mise.run) | `#!/bin/sh`, `set -eu` | `curl -#fLo` progress bar; `uname -o = Android` maps to musl; **embedded SHA256 for pinned release**; 24h minimum release age; prints activation instead of editing rc |
| deno install.sh | `#!/bin/sh`, `set -e` | Header: "Keep this script simple and easily auditable"; version as positional arg |
| flyctl install.sh | `#!/bin/sh`, `set -e` | `curl --progress-bar --retry 5`; **atomic install** (extract to tmp dir, `mv` into place); best-in-class PATH handling: drop-in `~/.bashrc.d/` files, asks via `/dev/tty`, prints manual steps when non-interactive |
| uv install.sh | `#!/bin/sh`, `set -u`, shellcheck'd | `verify_checksum` when known; glibc-version check with musl fallback; **env-file pattern** (`$HOME/.local/bin/env` sourced from rc files); shadowed-binary detection; install receipts |

## Anti-patterns

- `#!/bin/sh` shebang with bashisms (`[[ ]]`, arrays, `source`).
- No strict mode at all -- the #1 amateur tell.
- `set -euo pipefail` under `#!/bin/sh` (`pipefail` is a bashism).
