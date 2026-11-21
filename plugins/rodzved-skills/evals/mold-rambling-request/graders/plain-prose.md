---
type: regex
target: last_message
pattern: '(?:^|\n)[ \t]*(?:\*\*)?(?:Problem|Outcome|Done when|Settled|Open)(?:\*\*)?:|(?:^|\n)[ \t]*(?:[-*] |1\.)'
flags: i
match: not_contains
---
