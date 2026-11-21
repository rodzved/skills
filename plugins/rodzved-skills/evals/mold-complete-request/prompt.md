---
description: A complete request comes back as one fenced prompt, the user's details kept and none added.
max_turns: 4
allowed_tools: [Agent, Read, Grep, Glob, AskUserQuestion]
---

/rodzved-skills:mold Add email validation to the signup form. Right now it accepts addresses like "bob@", so about 40 welcome emails a week bounce and support cleans them up by hand. Done when an invalid address shows an inline error under the field, the form won't submit, and the weekly bounce count drops to near zero. Settled: validate in the browser and again in the API handler, keep the current form layout, and don't touch the login form. Open: I haven't decided whether to also check the domain's MX records; propose options before building that part.
