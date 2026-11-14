#!/bin/bash
# validate.sh — `claude plugin validate` on the marketplace and on each plugin
# folder (from the root, validate does not open the skill files of the plugins
# it lists), then checks that every plugin's folder, marketplace
# entry and manifest name agree. grep, not jq: Git Bash ships no jq.
#
# Not --strict: plugin.json has no version on purpose (each commit is a new
# version), and --strict fails on that warning. Errors still fail the check.
#
# Runs unchanged on Linux, macOS and Windows Git Bash. Without the claude CLI
# the check is skipped (exit 0) unless REQUIRE_TOOLS=1 (CI).
set -u
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

if ! command -v claude >/dev/null 2>&1; then
  if [ "${REQUIRE_TOOLS:-0}" = 1 ]; then echo "✗ claude CLI not found" >&2; exit 1; fi
  echo "skip: claude CLI not installed"; exit 0
fi

market=.claude-plugin/marketplace.json
bad=0
fail() { echo "✗ $*"; bad=$((bad + 1)); }

out=$(claude plugin validate . 2>&1) || { echo "$out"; fail "validate: marketplace"; }

count=0
for d in plugins/*/; do
  [ -d "$d" ] || continue
  d=${d%/}
  name=${d#plugins/}
  count=$((count + 1))
  out=$(claude plugin validate "$d" 2>&1) || { echo "$out"; fail "validate: $d"; }
  grep -q "\"source\": \"\./plugins/$name\"" "$market" \
    || fail "$market: no entry with \"source\": \"./plugins/$name\""
  grep -q "\"name\": \"$name\"" "$d/.claude-plugin/plugin.json" 2>/dev/null \
    || fail "$d/.claude-plugin/plugin.json: \"name\" is not \"$name\""
done

# validate accepts a source path that does not exist, so check the reverse too.
while IFS= read -r src; do
  [ -d "$src" ] || fail "$market: source $src is not a directory"
done < <(grep -oE '"source": *"\./plugins/[^"]*"' "$market" | sed -E 's/.*"(\.\/plugins\/[^"]*)"/\1/')

[ "$bad" -eq 0 ] && echo "validate: marketplace and $count plugin(s) pass" && exit 0
echo "✗ validate: $bad problem(s)" >&2
exit 1
