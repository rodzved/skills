---
type: llm
---

The user asked for their rambling request to be rewritten as a prompt for another session. Their request, verbatim:

> ok so the signup form thing. don't touch the login form btw, that one's fine. basically people type stuff like "bob@" and it just goes through?? then the welcome email bounces, about 40 a week, and support cleans them up by hand. and MX records, I dunno, maybe we should also check the domain's MX records, haven't decided, I'd want options on that before anyone builds it. anyway add email validation to the signup form. oh and validate in the browser and again in the API handler, both. keep the current form layout. I'll call it done when a bad address shows an inline error under the field, the form won't submit, and the weekly bounce count drops to near zero.

Something is invented when the response states a fact, number, name, requirement or decision that this request does not give: for example a library, a regex, a file or function name, a framework, an error message text, a test requirement, a deadline, or an open point or question the user did not raise. Rewording, reordering, restating the user's own words, and the user's own open point about MX records are not invented.

PASS if the response is a rewritten prompt, ordered so the task and its parts (problem, outcome, settled, open) are easy to follow, and nothing in it is invented.

FAIL if any of these holds:

- The response keeps the request in its original order and wording.
- Something in it is invented.
- It drops one of these facts: "bob@" goes through; about 40 welcome emails a week bounce; support cleans them up by hand; done means an inline error under the field, the form won't submit, and the weekly bounce count near zero; validate in the browser and again in the API handler; keep the current form layout; don't touch the login form; the MX check is undecided, with options wanted before it is built.
- It turns the open MX question into a decision.
