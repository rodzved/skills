#!/bin/bash
# eval-cases.sh — checks the structure of every eval case without running it
# (`claude plugin eval` has no dry run; loading a suite starts paid runs).
# Rules from the plugin-evals suite reference: a case is a folder with
# prompt.md or case.yaml, at least one grader, and a case.yaml with
# schema_version "1.1" and its name. Plus this repo's rules: the prompt invokes
# its own plugin, and a plugin with evals/ has an executable eval.sh.
# Runs unchanged on Linux, macOS and Windows Git Bash.
set -u
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

bad=0
cases=0
fail() { echo "✗ $*"; bad=$((bad + 1)); }

for evals in plugins/*/evals; do
  [ -d "$evals" ] || continue
  p=${evals#plugins/}
  p=${p%/evals}
  [ -x "plugins/$p/eval.sh" ] || fail "plugins/$p: evals/ without an executable eval.sh"

  for c in "$evals"/*/; do
    c=${c%/}
    name=${c##*/}
    case "$name" in results|mocks) continue ;; esac
    cases=$((cases + 1))

    [ -f "$c/prompt.md" ] || [ -f "$c/case.yaml" ] || fail "$c: no prompt.md or case.yaml"

    graders=0
    for g in "$c"/graders/*.md; do
      [ -f "$g" ] || continue
      graders=$((graders + 1))
      # The type: line must sit inside the leading --- frontmatter.
      awk 'NR == 1 && $0 != "---" { exit 1 }
           NR > 1 && $0 == "---" { exit found ? 0 : 1 }
           NR > 1 && /^type:/ { found = 1 }
           END { if (NR < 2) exit 1 }' "$g" || fail "$g: no type: in its frontmatter"
    done
    [ "$graders" -gt 0 ] || fail "$c: no graders/*.md"

    if [ -f "$c/case.yaml" ]; then
      grep -qE '^schema_version: *"1\.1"' "$c/case.yaml" || fail "$c/case.yaml: schema_version is not \"1.1\""
      grep -qE "^name: *\"?$name\"? *\$" "$c/case.yaml" || fail "$c/case.yaml: name is not $name"
      script=$(sed -nE 's/^ *scaffold_script: *"?([^" ]+)"? *$/\1/p' "$c/case.yaml")
      [ -z "$script" ] || [ -f "$c/$script" ] || fail "$c/case.yaml: scaffold_script $script not found"
    fi

    if [ -f "$c/prompt.md" ]; then
      # First non-empty line after the frontmatter.
      first=$(awk 'NR == 1 && $0 == "---" { fm = 1; next }
                   fm && $0 == "---" { fm = 0; next }
                   fm { next }
                   NF { print; exit }' "$c/prompt.md")
      case "$first" in "/$p:"*) ;; *) fail "$c/prompt.md: does not start with /$p:" ;; esac
    fi
  done
done

[ "$bad" -eq 0 ] && echo "eval cases: $cases case(s) well-formed" && exit 0
echo "✗ eval cases: $bad problem(s)" >&2
exit 1
