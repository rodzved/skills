---
type: llm
---

The user asked for their request to be rewritten, and expanded, as a prompt for another session. Their input, verbatim:

> "audit the server setup, security etc. not sure what else but make sure it's really hardened so I can add more apps" I want you to expand my wording. the server is the deploykit folder in my project

The rewriter could take a brief look at the deploykit folder, so facts about what that folder contains (its roles, files, ports, users, the proxy) are allowed, as are restatements of the user's own words.

Something is an invented decision when the response states a decision, requirement or way of working that this input does not give: for example an order of work for the task as a whole, a report format or ranking, an approval step such as "check with me before you make the fixes", a deadline, a tool to use, or a choice between options. Questions for the target agent, and open points that ask it to propose options or say what is undecided (such as what "hardened" should mean, or how more apps should be hosted), are not invented.

PASS if the response is a rewritten prompt and states no invented decision.

FAIL if any of these holds:

- It states an invented decision, requirement or way of working.
- It turns the user's "not sure what else" into a decided list of what the audit covers, instead of leaving it open.
