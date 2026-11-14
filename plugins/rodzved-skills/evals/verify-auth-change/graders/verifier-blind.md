---
type: llm
focus: trace
---

The session dispatches one agent to change how API keys are checked, then a second agent, a verifier, to prove that change. Judge the `prompt` the session passed in the verifier's Agent call.

PASS if that prompt states the task and how to check it, and passes on nothing the first agent reported: none of its summary, its test results or its assurance that the change works. Naming the commit to compare against is fine.

FAIL if the prompt relays any of the first agent's account of its work, or if the session dispatched no verifier.
