#!/bin/sh
# repo-audit.sh -- POSIX-sh checklist auditor for the oss-standards skill.
#
# Usage: repo-audit.sh <repo-dir>
# Checks a repository against the oss-standards NOW checklist and reports
# PASS/FAIL per item. Exit 0 when all NOW items pass, 1 otherwise.
# SOON items are reported as INFO only.
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

# NOW items
check "README.md exists" NOW test -f "$dir/README.md"
check "LICENSE exists" NOW test -f "$dir/LICENSE"
check "CHANGELOG.md exists" NOW test -f "$dir/CHANGELOG.md"
check ".gitignore exists" NOW test -f "$dir/.gitignore"
check ".github/workflows exists" NOW test -d "$dir/.github/workflows"
check "SECURITY.md exists" NOW test -f "$dir/SECURITY.md"
check "no binaries committed to git" NOW sh -c \
    '! git -C "$1" ls-files | grep -Eq "\.(exe|dll|so|dylib|bin|o|a)$"' sh "$dir"
check "install.sh has strict mode (set -eu or set -u)" NOW sh -c \
    '[ ! -f "$1/install.sh" ] || grep -Eq "^set -e?u" "$1/install.sh"' sh "$dir"
check "install.sh has no bashisms under #!/bin/sh" NOW sh -c \
    '[ ! -f "$1/install.sh" ] || ! grep -Eq "\[\[|\<function\>|\<source\>" "$1/install.sh"' sh "$dir"
check "workflows use least-privilege permissions" NOW sh -c \
    '! grep -rEq "permissions:[[:space:]]*write-all" "$1/.github/workflows" 2>/dev/null' sh "$dir"

# SOON items (informational)
for f in CONTRIBUTING.md CODE_OF_CONDUCT.md .github/dependabot.yml \
         .github/CODEOWNERS .shellcheckrc .editorconfig; do
    info "$f"
done

printf '%s\n' '---'
if [ "$fail" -eq 0 ]; then
    printf 'RESULT: all NOW items pass\n'
else
    printf 'RESULT: one or more NOW items failed\n'
fi
exit "$fail"
