<!--
  01-install-sh-fundamentals.md -- Reference for oss-standards.

  Covers: POSIX sh vs bash choice, strict-mode idioms, and dissections of
  eight professional installer scripts. Read when writing or reviewing a
  piped (`curl`-to-shell) installer.
-->

# install.sh fundamentals

## Algorithm

INPUT: the installer script (or a blank page for a new one).

1. **Pick the shell.** IF the script needs bash-only features (`[[ ]]`, arrays, `pipefail`) THEN use `#!/usr/bin/env bash` or `#!/bin/bash` and hard-error on other shells. ELSE use `#!/bin/sh` -- it exists on every Unix (minimal environments may ship only a basic `sh`, e.g. dash).
2. **Set strict mode.** IF shebang is `#!/bin/sh` THEN the script MUST contain `set -eu` on its own line. IF bash THEN it MUST contain `set -euo pipefail`. (`set -u` catches typo'd variable names; `set -e` turns silent corruption into a loud early exit.)
3. **Compensate for missing pipefail.** POSIX sh has no `pipefail`. IF `#!/bin/sh` THEN wrap fallible pipelines in explicit checks (rustup's `ensure` / `need_cmd` / `assert_nz`, e.g. `ensure curl "$url" -o "$file"`).
4. **Verify dialect consistency.** IF shebang is `#!/bin/sh` AND the body contains bashisms (`[[ ]]`, `function`, `source`, arrays, `pipefail`) THEN FAIL. IF shebang is `#!/bin/sh` AND the body contains `set -euo pipefail` THEN FAIL.
5. **Cross-check idioms** against the dissections below (verified 2026-10-12): TLS hardening, partial-download guard, non-standard prefix detection, rc-file policy, retry, atomic install.

## Reference implementations (dissected 2026-10-12)

| Script | Dialect | Notable idioms |
|---|---|---|
| rustup-init.sh | `#!/bin/sh`, `set -u` | TLS hardening `--proto '=https' --tlsv1.2`; `need_tty` reconnects piped stdin to `/dev/tty`; Android maps to `linux-android`; warns on noexec /tmp |
| nvm install.sh | `#!/usr/bin/env bash` | Whole script wrapped in `{ }` as a partial-download guard; idempotent profile append (grep-before-append); `=>` step lines |
| oh-my-zsh install.sh | `#!/bin/sh`, `set -e` | Detects non-standard install prefixes via `case "$PREFIX"` (single-user environments); never destroys `.zshrc` (renames to `.zshrc.pre-oh-my-zsh`); documents "Manual Inspection" (download, inspect, run) |
| Homebrew install.sh | `#!/bin/bash`, `set -u` | Aborts on root; `retry` with exponential backoff; `ohai`/`warn`/`execute` helpers; **never edits rc files -- prints "Next steps"** |
| mise (mise.run) | `#!/bin/sh`, `set -eu` | `curl -#fLo` progress bar; `uname -o = Android` maps to musl; **embedded SHA256 for pinned release**; 24h minimum release age; prints activation instead of editing rc |
| deno install.sh | `#!/bin/sh`, `set -e` | Header: "Keep this script simple and easily auditable"; version as positional arg |
| flyctl install.sh | `#!/bin/sh`, `set -e` | `curl --progress-bar --retry 5`; **atomic install** (extract to tmp dir, `mv` into place); best-in-class PATH handling: drop-in `~/.bashrc.d/` files, asks via `/dev/tty`, prints manual steps when non-interactive |
| uv install.sh | `#!/bin/sh`, `set -u`, shellcheck'd | `verify_checksum` when known; glibc-version check with musl fallback; **env-file pattern** (`$HOME/.local/bin/env` sourced from rc files); shadowed-binary detection; install receipts |

## FLAG on sight (FAIL)

- No strict mode at all -- the #1 amateur tell.
- `#!/bin/sh` shebang with bashisms.
- `set -euo pipefail` under `#!/bin/sh`.
