#!/bin/sh
# repo-audit.sh -- POSIX-sh checklist auditor for the oss-standards skill.
#
# Usage: repo-audit.sh <repo-dir>
# Checks a repository against the oss-standards NOW checklist and reports
# PASS/FAIL per item. Exit 0 when all NOW items pass, 1 otherwise.
# SOON items are reported as INFO only.
#
# This script covers the fast, fully-automated subset of
# references/15a-scoring-algorithm.md as NOW checks:
#   I1, I2, I3, I4-presence (installer: strict mode, no bashisms,
#   TLS hardening, SHA256 checksum present -- fail-closed tracing is
#   a human rubric, see below), R1, R2, R4 (required files, no
#   binaries, workflows dir), V3 (tag/changelog consistency),
#   L2 (SPDX identifier), C2, C3, C4 (CI/CD hardening).
# SOON items (CONTRIBUTING, CoC, dependabot, CODEOWNERS, shellcheckrc,
# editorconfig, scorecard workflow) are reported as INFO only.
# Items needing human judgment (I4 fail-closed trace, I6, I7, I8, R3,
# R5, R6, V1, V2, V4, V5, V6, L1, L3, L4, P1, P2, P3, C1, C5, S1-S5)
# are rubric inputs -- see the algorithm reference. A fully compliant
# repo scores 100 there.
set -eu

dir=${1:?usage: repo-audit.sh <repo-dir>}
fail=0

check() { # $1 = label, $2 = phase (NOW/SOON), $3... = test command
    label=$1; phase=$2; shift 2
    if "$@" >/dev/null 2>&1; then
        printf 'PASS [%s] %s\n' "$phase" "$label"
    else
        printf 'FAIL [%s] %s\n' "$phase" "$label"
        [ "$phase" = "NOW" ] && fail=1
    fi
}

info() { # $1 = label (SOON items, informational)
    if [ -e "$dir/$1" ]; then
        printf 'PASS [SOON] %s\n' "$1"
    else
        printf 'INFO [SOON] %s missing (not required yet)\n' "$1"
    fi
}

printf 'oss-standards repo audit: %s\n' "$dir"
printf '%s\n' '---'

# --- NOW: required files -----------------------------------------------------
check "README.md exists" NOW test -f "$dir/README.md"
check "LICENSE exists" NOW test -f "$dir/LICENSE"
check "CHANGELOG.md exists" NOW test -f "$dir/CHANGELOG.md"
check ".gitignore exists" NOW test -f "$dir/.gitignore"
check ".github/workflows exists" NOW test -d "$dir/.github/workflows"
check "SECURITY.md exists" NOW test -f "$dir/SECURITY.md"
check "no binaries committed to git" NOW sh -c \
    '! git -C "$1" ls-files | grep -Eq "\.(exe|dll|so|dylib|bin|o|a)$"' sh "$dir"

# --- NOW: installer ----------------------------------------------------------
check "install.sh has strict mode (set -eu)" NOW sh -c \
    '[ ! -f "$1/install.sh" ] || grep -Eq "^set -eu$" "$1/install.sh"' sh "$dir"
check "install.sh has no bashisms under #!/bin/sh" NOW sh -c \
    '[ ! -f "$1/install.sh" ] || ! grep -Eq "\[\[|\<function\>|\<source\>|pipefail" "$1/install.sh"' sh "$dir"
check "install.sh hardens TLS (--proto '=https' --tlsv1.2)" NOW sh -c \
    'f="$1/install.sh"; [ ! -f "$f" ] && exit 0
     # skip when curl is never invoked (invocation = curl + flag/quote)
     grep -Eq "curl[[:space:]]+-" "$f" ||
     grep -Eq "curl[[:space:]]+\"" "$f" ||
     grep -Eq "curl[[:space:]]+'"'"'" "$f" || exit 0
     grep -qF -- "--proto '"'"'=https'"'"'" "$f" &&
     grep -qF -- "--tlsv1.2" "$f"' sh "$dir"
check "install.sh verifies SHA256 checksums" NOW sh -c \
    '[ ! -f "$1/install.sh" ] || grep -qi "sha256" "$1/install.sh"' sh "$dir"
# NOTE: fail-closed tracing (missing/bad checksum -> nonzero exit) is a
# human rubric (criterion I4 in 15a-scoring-algorithm.md), not grep-able.

# --- NOW: SPDX identifier ----------------------------------------------------
# Heuristic subset of common OSI-approved SPDX IDs.
# Full list: https://spdx.org/licenses (currently 3.29.0).
SPDX_IDS="MIT Apache-2.0 BSD-2-Clause BSD-3-Clause ISC MPL-2.0
    GPL-2.0-only GPL-2.0-or-later GPL-3.0-only GPL-3.0-or-later
    LGPL-2.1-only LGPL-2.1-or-later LGPL-3.0-only LGPL-3.0-or-later
    AGPL-3.0-only AGPL-3.0-or-later EPL-2.0 EPL-1.0 EUPL-1.2
    CC0-1.0 Unlicense Zlib Artistic-2.0 OFL-1.1 PSF-2.0"
spdx_id=""
if [ -f "$dir/README.md" ]; then
    spdx_id=$(grep -oE 'SPDX-License-Identifier:[[:space:]]*[A-Za-z0-9.+:-]+' \
        "$dir/README.md" 2>/dev/null | head -n 1 | sed 's/^[^:]*:[[:space:]]*//')
    if [ -z "$spdx_id" ]; then
        # shields.io badge form: badge/License-MIT-yellow.svg
        spdx_id=$(grep -oE 'badge/License-[A-Za-z0-9.+:-]+' "$dir/README.md" \
            2>/dev/null | head -n 1 | sed 's/.*License-//; s/-[a-z][a-z]*\(\.svg\)\?$//')
    fi
fi
check "README has a valid SPDX license identifier" NOW sh -c \
    'id=$1; ids=$2
     [ -n "$id" ] || exit 1
     case " $ids " in *" $id "*) exit 0;; *) exit 1;; esac' \
    sh "$spdx_id" "$SPDX_IDS"

# --- NOW: CI/CD hardening ----------------------------------------------------
check "workflows use least-privilege permissions" NOW sh -c \
    '! grep -rEq "permissions:[[:space:]]*write-all" "$1/.github/workflows" 2>/dev/null' sh "$dir"
check "every workflow has a top-level permissions: block" NOW sh -c \
    'd="$1/.github/workflows"; [ -d "$d" ] || exit 0
     for f in "$d"/*.yml "$d"/*.yaml; do
         [ -f "$f" ] || continue
         grep -q "^permissions:" "$f" || exit 1
     done' sh "$dir"
check "third-party actions are SHA-pinned (40-hex)" NOW sh -c \
    'd="$1/.github/workflows"; [ -d "$d" ] || exit 0
     for f in "$d"/*.yml "$d"/*.yaml; do
         [ -f "$f" ] || continue
         grep -E "uses:[[:space:]]+[^[:space:]]" "$f" 2>/dev/null \
           | grep -vE "uses:[[:space:]]*\"?(\\./|docker://)" \
           | grep -vE "@[0-9a-fA-F]{40}([^0-9a-fA-F]|$)" \
           | grep -q . && exit 1
     done' sh "$dir"

# --- NOW: versioning consistency ---------------------------------------------
check "every vX.Y.Z tag has a CHANGELOG.md heading" NOW sh -c \
    'cd "$1" 2>/dev/null || exit 0
     git rev-parse --git-dir >/dev/null 2>&1 || exit 0
     [ -f CHANGELOG.md ] || exit 1
     for t in $(git tag -l "v[0-9]*" 2>/dev/null); do
         v=${t#v}
         case "$v" in *[!0-9.]* ) continue;; esac
         grep -q "## \[$v\]" CHANGELOG.md || exit 1
     done' sh "$dir"

# --- SOON items (informational) ----------------------------------------------
for f in CONTRIBUTING.md CODE_OF_CONDUCT.md .github/dependabot.yml \
         .github/CODEOWNERS .shellcheckrc .editorconfig \
         .github/workflows/scorecard.yml; do
    info "$f"
done

printf '%s\n' '---'
if [ "$fail" -eq 0 ]; then
    printf 'RESULT: all NOW items pass\n'
else
    printf 'RESULT: one or more NOW items failed\n'
fi
exit "$fail"
