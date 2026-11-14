#!/bin/bash
# line-endings.sh — every tracked or new text file must be stored AND checked
# out with LF. bash (eval.sh, the fixtures, the tests) breaks on CRLF, and
# .gitattributes (`* text=auto eol=lf`) only protects files committed after it
# was added. `git ls-files --eol` reports the index (i/) and the working tree
# (w/) per file, so an editor that re-saved a file as CRLF is caught before it
# is committed. Runs unchanged on Linux, macOS and Windows Git Bash.
set -u
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

bad=0
while IFS= read -r line; do
  case "$line" in
    i/crlf*|i/mixed*|*" w/crlf "*|*" w/mixed "*)
      echo "✗ CRLF: $line"; bad=$((bad + 1)) ;;
  esac
done < <(git ls-files --eol -co --exclude-standard)

[ "$bad" -eq 0 ] && echo "line endings: all LF" && exit 0
echo "✗ $bad file(s) with CRLF — convert with: git add --renormalize ." >&2
exit 1
