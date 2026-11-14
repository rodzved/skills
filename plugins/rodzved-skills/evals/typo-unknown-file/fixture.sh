#!/usr/bin/env bash
set -e
mkdir -p docs src
printf '# Guide\n\nClients recieve a token after login.\n' > docs/guide.md
printf '# Changelog\n\nNothing yet.\n' > docs/changelog.md
printf 'def login():\n    return "token"\n' > src/app.py
git init -q
