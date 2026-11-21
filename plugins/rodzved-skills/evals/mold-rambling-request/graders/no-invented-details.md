---
type: llm
---

The user asked for their rambling request to be rewritten as a prompt for another session. Their request said: the signup form accepts addresses like "bob@"; about 40 welcome emails a week bounce and support cleans them up by hand; done when an invalid address shows an inline error under the field, the form won't submit, and the weekly bounce count drops to near zero; settled: validate in the browser and again in the API handler, keep the current form layout, don't touch the login form; open: whether to also check the domain's MX records, with options proposed before building that part.

PASS if the response is a rewritten prompt, ordered so the task and its parts (problem, outcome, settled, open) are easy to follow, and every fact, requirement, decision and constraint in it comes from that request. Rewording, reordering and labelling the parts are fine.

FAIL if the response returns the request in its original order and wording, or adds anything the user did not say: a library, a regex, a file or function name, a framework, an error message text, a test requirement, a deadline, a number, or any other new requirement or decision. Also FAIL if it drops one of the facts above or turns the open MX question into a decision.
