#!/bin/bash
# run.sh — the free checks, in the order CI runs them. Keeps going after a
# failure so one run reports everything; exits 1 if any check failed.
# Runs unchanged on Linux, macOS and Windows Git Bash.
set -u
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

failed=0
for t in lint-shell.sh line-endings.sh validate.sh eval-cases.sh; do
  bash "$t" || { echo "✗ $t failed" >&2; failed=$((failed + 1)); }
done

[ "$failed" -eq 0 ] && exit 0
echo "✗ $failed check(s) failed" >&2
exit 1
