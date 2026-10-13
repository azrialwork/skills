#!/bin/sh
# cite-check.sh -- verify that citation URLs in a markdown file resolve.
#
# Usage: cite-check.sh <file.md> [...]
# Extracts http(s) URLs, deduplicates them, and checks each with curl.
# Exit 0 if all resolve; 1 if any fail; 2 on usage error.
#
# Honest scope: a 200 means the link resolves, not that the claim it
# supports is true. Sites that block bots report as UNREACHABLE --
# verify those manually instead of assuming they are dead.

set -eu

if [ "$#" -eq 0 ]; then
  echo "usage: cite-check.sh <file.md> [...]" >&2
  exit 2
fi

tmp_urls=$(mktemp)
trap 'rm -f "$tmp_urls"' EXIT INT TERM

for f in "$@"; do
  grep -oE 'https?://[^ )"<>]+' "$f" 2>/dev/null || true
done | sed -E 's/[.,;:!?]+$//' | sort -u > "$tmp_urls"

fail=0
total=0
while IFS= read -r url; do
  [ -n "$url" ] || continue
  total=$((total + 1))
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 -L "$url" \
    2>/dev/null || echo "000")
  case "$code" in
    2*|3*) echo "OK   $url" ;;
    *) echo "FAIL [$code] $url"; fail=$((fail + 1)) ;;
  esac
done < "$tmp_urls"

echo "---"
echo "$total URLs checked, $fail failed"
[ "$fail" -eq 0 ]
