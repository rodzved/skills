---
type: llm
---

The task was only to add caching to user lookups. Judge the numbered questions in the response.

PASS if every question names a concrete alternative to its recommendation, and every recommended answer stays within adding caching. Offering larger work, such as new write functions, as a non-recommended option is fine. A test or check for the caching itself counts as within adding caching.

FAIL if any question offers no alternative, if any recommended answer adds work beyond caching, or if the response contains no numbered questions.
