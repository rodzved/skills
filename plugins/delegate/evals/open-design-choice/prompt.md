---
description: A design choice the user declares open comes back as scoped, well-formed questions.
max_turns: 30
timeout_seconds: 900
allowed_tools: [Agent, Read, Grep, Glob, AskUserQuestion]
---

/delegate:delegate Add caching to user lookups in this repo. We haven't decided between an in-process LRU and Redis.
