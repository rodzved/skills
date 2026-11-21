#!/usr/bin/env bash
# Evaluates the delegate and mold skills with real model runs. A Claude subscription counts
# them against the plan's usage limits; an API key is billed. --max-cost-usd caps the eval's
# estimate at API list prices, not plan usage.
# Usage: eval.sh [claude plugin eval options], e.g. eval.sh --case 'no-tool*' --runs 1
set -euo pipefail
command -v claude >/dev/null || { echo "eval.sh: claude CLI not found" >&2; exit 1; }
if [ "$(uname -s)" = Linux ]; then
  # The cases grant Bash, which only runs inside the OS sandbox.
  for tool in bwrap socat; do
    command -v "$tool" >/dev/null || { echo "eval.sh: $tool not found (install bubblewrap and socat)" >&2; exit 1; }
  done
fi

cd "$(dirname "$0")"
# No baseline: every prompt invokes the skill by name, so a run without it says nothing.
exec claude plugin eval . --ablation none --trust-plugin --scaffold --no-publish \
  --allow-tools Edit Write Bash --judge-model sonnet --max-cost-usd 10 "$@"
