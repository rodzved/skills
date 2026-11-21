---
type: regex
target: last_message
pattern: '^\s*(?:[^\n`]*(?:clear|specific|precise|unambiguous)[^\n`]*\n\s*```[^\n]*\n(?:(?!```)[\s\S])*```|```[^\n]*\n(?:(?!```)[\s\S])*```[ \t]*\n\s*[^\n`]*(?:clear|specific|precise|unambiguous)[^\n`]*)\s*$'
flags: i
---
