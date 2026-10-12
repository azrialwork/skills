#!/bin/sh
# commit-lint.sh -- validate a commit message against Conventional Commits.
#
# Usage: commit-lint.sh <file>        (e.g. as a commit-msg hook: commit-lint.sh "$1")
#        printf 'feat: x' | commit-lint.sh
# Exit 0 when the message is valid, 1 with a reason on stderr otherwise.
# POSIX sh. ASCII only.

fail() { printf 'commit-lint: %s\n' "$1" >&2; exit 1; }

if [ $# -gt 0 ]; then
    [ -f "$1" ] || fail "file not found: $1"
    msg=$(cat "$1")
else
    msg=$(cat)
fi

# strip comment lines (git appends them in commit-msg hook context)
subject=$(printf '%s' "$msg" | grep -v '^#' | grep -m1 .)
[ -n "$subject" ] || fail "empty commit message"

# subject must match <type>[optional (scope)][optional !]: <description>
case "$subject" in
    *": "*)
        head=${subject%%: *}
        desc=${subject#*: }
        ;;
    *)
        fail "subject must match '<type>[optional scope]: <description>' -- got: $subject"
        ;;
esac

case "$head" in
    *"!"*) bang=1; head=${head%%"!"*} ;;
    *) bang=0 ;;
esac

case "$head" in
    *"("*")")
        type=${head%%"("*}
        scope=${head#*"("}; scope=${scope%")"}
        [ -n "$scope" ] || fail "empty scope in: $subject"
        ;;
    *)
        type=$head
        ;;
esac

case "$type" in
    feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert) ;;
    *) fail "unknown type '$type' (want feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)" ;;
esac

[ -n "$desc" ] || fail "empty description in: $subject"

case "$desc" in
    [A-Z]*) fail "description must start lowercase -- got: $desc" ;;
esac

case "$desc" in
    *.) fail "description must not end with a period -- got: $desc" ;;
esac

[ "${#desc}" -le 72 ] || fail "description longer than 72 chars (${#desc}) -- got: $desc"

# body lines wrap at 72 chars
bad=$(printf '%s' "$msg" | grep -v '^#' | tail -n +2 | awk 'length > 72 {print NR+1}' | head -1)
[ -z "$bad" ] || fail "body line $bad longer than 72 chars"

if [ "$bang" -eq 1 ]; then
    printf '%s' "$msg" | grep -q "BREAKING CHANGE" || \
        printf 'commit-lint: note: breaking change without BREAKING CHANGE footer\n' >&2
fi

exit 0
