#!/bin/bash
# lint-shell.sh — shellcheck every bash script in the repo (each plugin's
# eval.sh, the eval fixtures, tests/). Warning severity and up fails;
# info/style is noise we do not gate on.
#
# Runs unchanged on Linux, macOS and Windows Git Bash. Without shellcheck the
# check is skipped (exit 0) unless REQUIRE_TOOLS=1 (CI), which turns a missing
# tool into a failure.
set -u
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

if ! command -v shellcheck >/dev/null 2>&1; then
  if [ "${REQUIRE_TOOLS:-0}" = 1 ]; then echo "✗ shellcheck not found" >&2; exit 1; fi
  echo "skip: shellcheck not installed (https://www.shellcheck.net/)"; exit 0
fi

# Every tracked or new (not ignored) file whose first line is a sh/bash shebang.
files=()
while IFS= read -r f; do
  case "$(head -n1 "$f" 2>/dev/null)" in '#!'*sh*) files+=("$f") ;; esac
done < <(git ls-files -co --exclude-standard)

# C.UTF-8: shellcheck aborts printing a finding on a line with ✗/→ otherwise.
# -P SCRIPTDIR: resolve a `source` relative to the script's own folder.
LC_ALL=C.UTF-8 shellcheck -x -P SCRIPTDIR -S warning "${files[@]}" || exit 1
echo "shellcheck: ${#files[@]} scripts clean"
