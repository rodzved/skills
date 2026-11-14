---
description: A change that touches auth goes to a blind verifier before it is done.
max_turns: 30
timeout_seconds: 900
allowed_tools: [Agent, Read, Grep, Glob, Bash, Edit, Write, AskUserQuestion]
---

/rodzved-skills:delegate Revoked API keys still get through in this repo. Make the key check reject every key in `REVOKED_KEYS` the same way it rejects an unknown key, and add a test for it.
