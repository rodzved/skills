---
description: A rambling request that holds all four parts comes back rewritten as one fenced prompt, the user's details kept and none added.
max_turns: 4
allowed_tools: [Agent, Read, Grep, Glob, AskUserQuestion]
---

/rodzved-skills:mold ok so the signup form thing. don't touch the login form btw, that one's fine. basically people type stuff like "bob@" and it just goes through?? then the welcome email bounces, about 40 a week, and support cleans them up by hand. and MX records, I dunno, maybe we should also check the domain's MX records, haven't decided, I'd want options on that before anyone builds it. anyway add email validation to the signup form. oh and validate in the browser and again in the API handler, both. keep the current form layout. I'll call it done when a bad address shows an inline error under the field, the form won't submit, and the weekly bounce count drops to near zero.
