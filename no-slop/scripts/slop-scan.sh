#!/bin/sh
# slop-scan.sh -- Heuristic AI-slop scanner for the no-slop skill.
#
# Usage: slop-scan.sh <text-file> [phrases-file]
#
# Checks the file against assets/slop-phrases.txt plus structural
# heuristics. Three scoring modes, selected by markers in the phrases file:
#   # @shots            -- 2 points per matched line (lexical tells)
#   # @density:<group>  -- hits pooled per group, scored by density per
#                          1000 words (2+ hits required; single hits are
#                          normal prose): >=12 -> +8, >=6 -> +5, >=2 -> +2.
#   # @cluster:<group>  -- Tier 2 rule: 2+ DISTINCT patterns of the group
#                          inside one paragraph (blank-line separated)
#                          scores +3 per paragraph.
# Structural checks: bullet ratio, bold spam, non-ASCII/emoji. Em dash
# (H-02) and sycophancy/throat-clearing openers (H-03) are hard fails
# (+50 each, either alone guarantees FAIL) -- both rules are absolute.
# Burstiness (sentence-length coefficient of variation) is reported as
# INFORMATION ONLY -- it is a weak solo signal, never scored.
#
# Prints hits with line numbers and a slop score.
# Exit 0 when the score is at or under the threshold, 1 above it.
# This script is the mechanical floor, not the verdict: the Delivery Gate
# (references/03-self-audit.md) and the 0-100 algorithm
# (references/04a-scoring-algorithm.md) decide whether text is good.
set -eu

file=${1:?usage: slop-scan.sh <text-file> [phrases-file]}
phrases=${2:-$(dirname "$0")/../assets/slop-phrases.txt}
threshold=10
score=0

hit() { # $1 = points, $2 = message
    score=$((score + $1))
    printf 'HIT +%d: %s\n' "$1" "$2"
}
info() { # $1 = message
    printf 'info: %s\n' "$1"
}

[ -f "$file" ] || { printf 'error: no such file: %s\n' "$file" >&2; exit 2; }
[ -f "$phrases" ] || { printf 'error: no such phrases file: %s\n' "$phrases" >&2; exit 2; }

words=$(wc -w < "$file")
[ "$words" -gt 0 ] || { printf 'empty file\n'; exit 0; }

# --- 1. phrase list ----------------------------------------------------------
tmpd=$(mktemp -d)
trap 'rm -rf "$tmpd"' EXIT INT TERM
mode=shot
dgroup=""

while IFS= read -r pat || [ -n "$pat" ]; do
    case "$pat" in
        '# @shots') mode=shot; dgroup=""; continue ;;
        '# @density:'*) mode=density; dgroup=${pat#'# @density:'}; : > "$tmpd/dens-$dgroup"; continue ;;
        '# @cluster:'*) mode=cluster; dgroup=${pat#'# @cluster:'}; : > "$tmpd/clust-$dgroup"; continue ;;
        ''|\#*|\<*|--\>*) continue ;;
    esac
    # single words get -w (word boundaries); multi-word phrases use plain -F
    case "$pat" in
        *\ *) wopt="" ;;
        *)    wopt="-w" ;;
    esac
    if [ "$mode" = density ]; then
        printf '%s|%s\n' "$wopt" "$pat" >> "$tmpd/dens-$dgroup"
        continue
    fi
    if [ "$mode" = cluster ]; then
        printf '%s|%s\n' "$wopt" "$pat" >> "$tmpd/clust-$dgroup"
        continue
    fi
    # shellcheck disable=SC2086
    matches=$(grep -inF $wopt "$pat" "$file" || true)
    [ -n "$matches" ] || continue
    n=$(printf '%s\n' "$matches" | wc -l)
    lines=$(printf '%s\n' "$matches" | cut -d: -f1 | tr '\n' ',' | sed 's/,$//')
    hit $((n * 2)) "phrase '$pat' x$n (lines $lines)"
done < "$phrases"

# --- 1b. density verdicts ----------------------------------------------------
# Anchors: hedge density >= 6/1000w is an established high-signal heuristic
# (AI-vocab >= 15/1000w in practitioner literature); the ramp below extends
# it symmetrically. Per-group cap keeps one soft signal from dominating.
density_points() { # $1 = hits, $2 = words, $3 = label
    hits=$1; w=$2; label=$3
    # A single isolated hit is normal prose, not stacking:
    # density scoring only applies at 2+ hits.
    if [ "$hits" -lt 2 ]; then
        info "$label: only $hits hit(s) -- single occurrences not scored"
        return 0
    fi
    d=$((hits * 1000 / w))
    if [ "$d" -ge 12 ]; then pts=8
    elif [ "$d" -ge 6 ]; then pts=5
    elif [ "$d" -ge 2 ]; then pts=2
    else pts=0; fi
    if [ "$pts" -gt 0 ]; then
        hit "$pts" "$label density ${d}/1000w ($hits hits)"
    else
        info "$label density ${d}/1000w ($hits hits) -- below threshold"
    fi
}
for gf in "$tmpd"/dens-*; do
    [ -f "$gf" ] || continue
    g=${gf##*/dens-}
    hits=0
    while IFS='|' read -r wopt pat || [ -n "$pat" ]; do
        [ -n "$pat" ] || continue
        # shellcheck disable=SC2086
        n=$(grep -cF $wopt -i -- "$pat" "$file" || true)
        hits=$((hits + n))
        [ "$n" -gt 0 ] && info "density[$g] pattern '$pat' x$n"
    done < "$gf"
    density_points "$hits" "$words" "density[$g]"
done

# --- 1c. cluster verdicts ----------------------------------------------------
# Tier 2 (adapted from avoid-ai-writing): each word is legitimate alone;
# 2+ DISTINCT words of the group inside one paragraph (blank-line
# separated) is the rewrite signal. +3 per offending paragraph.
for cf in "$tmpd"/clust-*; do
    [ -f "$cf" ] || continue
    g=${cf##*/clust-}
    pdir="$tmpd/paras-$g"
    mkdir -p "$pdir"
    awk 'BEGIN{RS=""; n=0} {n++; f="'$pdir'/p" n ".txt"; print $0 > f; close(f); print n}' \
        "$file" > "$pdir/index"
    while read -r pn; do
        pf="$pdir/p$pn.txt"
        c=0; names=""
        while IFS='|' read -r wopt pat || [ -n "$pat" ]; do
            [ -n "$pat" ] || continue
            # shellcheck disable=SC2086
            if grep -qiF $wopt -- "$pat" "$pf" 2>/dev/null; then
                c=$((c + 1)); names="$names'$pat' "
            fi
        done < "$cf"
        if [ "$c" -ge 2 ]; then
            hit 3 "cluster[$g]: $c distinct words ($names) in paragraph $pn"
        fi
    done < "$pdir/index"
done

# --- 2. structural heuristics ------------------------------------------------
total=$(grep -c . "$file" || true)

bullets=$(grep -cE '^[[:space:]]*[-*][[:space:]]' "$file" || true)
if [ "$total" -gt 10 ] && [ $((bullets * 2)) -gt "$total" ]; then
    hit 5 "bullet spam: $bullets of $total lines are bullets (P-01)"
fi

bolds=$(grep -o '\*\*' "$file" | wc -l)
if [ "$bolds" -gt 20 ]; then
    hit 5 "bold spam: $bolds bold markers (P-02)"
fi

nonascii=$(LC_ALL=C grep -n '[^ -~]' "$file" | cut -d: -f1 | tr '\n' ',' | sed 's/,$//' || true)
if [ -n "$nonascii" ]; then
    hit 3 "non-ASCII characters (possible emoji) on lines $nonascii (Q-04)"
fi

first=$(grep -m1 . "$file" || true)
lower=$(printf '%s' "$first" | tr '[:upper:]' '[:lower:]')
# H-03 is absolute: a sycophancy/throat-clearing opener is a hard fail,
# not a soft heuristic. The pattern list is intentionally narrow (first
# text block only) to avoid false positives deeper in the text.
case "$lower" in
    *great\ question*|*excellent\ question*|*as\ an\ ai*|*certainly!*|*fantastic\ point*)
        hit 50 "HARD FAIL (H-03): sycophancy/throat-clearing opener: $first" ;;
    *"you're right"*|*"you are right"*|*absolutely*)
        hit 50 "HARD FAIL (H-03): sycophancy/throat-clearing opener: $first" ;;
esac

# --- 2b. hard gate: em dash (H-02) -------------------------------------------
emdash_lines=$(LC_ALL=C grep -n "$(printf '\342\200\224')" "$file" | cut -d: -f1 | tr '\n' ',' | sed 's/,$//' || true)
if [ -n "$emdash_lines" ]; then
    hit 50 "HARD FAIL (H-02): em dash character on lines $emdash_lines"
fi

# --- 2c. burstiness: sentence-length CV (informational only) ------------------
# Human prose varies sentence length widely (CV often > 60); model output
# defaults to uniform 15-20 word sentences (CV often < 30). Weak solo
# signal -- reported, never scored. Needs > 4 sentences to mean anything.
burst=$(awk '
    { n = split($0, parts, /[.!?]+/)
      for (i = 1; i <= n; i++) {
          c = split(parts[i], w, /[ \t]+/); k = 0
          for (j = 1; j <= c; j++) if (w[j] != "") k++
          if (k > 0) { sc++; sum += k; sumsq += k*k }
      } }
    END {
      if (sc > 4) {
        mean = sum / sc; var = sumsq / sc - mean * mean
        if (var < 0) var = 0
        cv = (mean > 0) ? sqrt(var) / mean * 100 : 0
        printf "sentences=%d mean_len=%.1f cv=%.0f", sc, mean, cv
      } else { printf "too few sentences" }
    }' "$file")
info "burstiness: $burst (CV < 30 uniform/AI-like, > 60 varied/human-like; not scored)"

# --- 3. verdict --------------------------------------------------------------
printf '%s\n' '---'
printf 'slop score: %d (threshold %d)\n' "$score" "$threshold"
if [ "$score" -gt "$threshold" ]; then
    printf 'RESULT: FAIL -- rewrite flagged passages, then rescan\n'
    exit 1
fi
printf 'RESULT: PASS\n'
exit 0
