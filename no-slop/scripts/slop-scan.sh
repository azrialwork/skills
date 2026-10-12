#!/bin/sh
# slop-scan.sh -- Heuristic AI-slop scanner for the no-slop skill.
#
# Usage: slop-scan.sh <text-file>
# Checks the file against assets/slop-phrases.txt plus structural
# heuristics (bullet ratio, bold spam, non-ASCII/emoji, sycophancy
# openers). Prints hits with line numbers and a slop score.
# Exit 0 when the score is at or under the threshold, 1 above it.
set -eu

file=${1:?usage: slop-scan.sh <text-file>}
phrases=${2:-$(dirname "$0")/../assets/slop-phrases.txt}
threshold=10
score=0

hit() { # $1 = points, $2 = message
    score=$((score + $1))
    printf 'HIT +%d: %s\n' "$1" "$2"
}

[ -f "$file" ] || { printf 'error: no such file: %s\n' "$file" >&2; exit 2; }

# --- 1. phrase list ----------------------------------------------------------
while IFS= read -r pat || [ -n "$pat" ]; do
    case "$pat" in ''|\#*|\<*|--\>*) continue ;; esac
    # single words get -w (word boundaries); multi-word phrases use plain -F
    case "$pat" in
        *\ *) wopt="" ;;
        *)    wopt="-w" ;;
    esac
    # shellcheck disable=SC2086
    matches=$(grep -inF $wopt "$pat" "$file" || true)
    if [ -n "$matches" ]; then
        n=$(printf '%s\n' "$matches" | wc -l)
        lines=$(printf '%s\n' "$matches" | cut -d: -f1 | tr '\n' ',' | sed 's/,$//')
        hit $((n * 2)) "phrase '$pat' x$n (lines $lines)"
    fi
done < "$phrases"

# --- 2. structural heuristics ------------------------------------------------
total=$(grep -c . "$file" || true)
[ "$total" -gt 0 ] || { printf 'empty file\n'; exit 0; }

bullets=$(grep -cE '^[[:space:]]*[-*][[:space:]]' "$file" || true)
if [ "$total" -gt 10 ] && [ $((bullets * 2)) -gt "$total" ]; then
    hit 5 "bullet spam: $bullets of $total lines are bullets"
fi

bolds=$(grep -o '\*\*' "$file" | wc -l)
if [ "$bolds" -gt 20 ]; then
    hit 5 "bold spam: $bolds bold markers"
fi

nonascii=$(LC_ALL=C grep -n '[^ -~]' "$file" | cut -d: -f1 | tr '\n' ',' | sed 's/,$//' || true)
if [ -n "$nonascii" ]; then
    hit 3 "non-ASCII characters (possible emoji) on lines $nonascii"
fi

first=$(grep -m1 . "$file" || true)
lower=$(printf '%s' "$first" | tr '[:upper:]' '[:lower:]')
case "$lower" in
    *great\ question*|*excellent\ question*|*absolutely*|*fantastic\ point*)
        hit 5 "sycophancy/throat-clearing opener: $first" ;;
    *"you're right"*|*"you are right"*)
        hit 5 "sycophancy/throat-clearing opener: $first" ;;
esac

# --- 3. verdict --------------------------------------------------------------
printf '%s\n' '---'
printf 'slop score: %d (threshold %d)\n' "$score" "$threshold"
if [ "$score" -gt "$threshold" ]; then
    printf 'RESULT: FAIL -- rewrite flagged passages, then rescan\n'
    exit 1
fi
printf 'RESULT: PASS\n'
exit 0
