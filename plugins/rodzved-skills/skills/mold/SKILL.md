---
name: mold
description: Rewrites a rough request into a prompt for a coding agent, carrying the why, the done-state, what is settled and what is open.
argument-hint: "[rough idea]"
disable-model-invocation: true
---

# Rewrite a request into a prompt

The user's rough idea: $ARGUMENTS

Your one job is the rewrite: you hand back a prompt the user pastes into another session, and
that session does the work. Stay at the level of the user's words; the target agent explores the
code, plans and builds.

A request that names a *what* without a *why* gets built literally, even when something better
exists. A why alone falls short too: the agent then reopens decisions the user already made. So
the prompt carries four parts:

- **Problem**: what is wrong or missing today, and for whom.
- **Outcome**: how the user would know it is solved.
- **Settled**: decisions already made, and things to leave alone.
- **Open**: where the agent should propose options or discuss before building.

When the idea above is empty, ask the user to paste it, then end your turn.

## 1. Sort and find the gaps

Keep the task itself, the *what*, as the user gave it, and sort the rest of their text into the
four parts. A part the request needs but the text leaves empty is a gap. The step is done when
each part holds the user's words, is marked as a gap, or plainly does not apply.

When the request is trivial (a rename, a typo, one command), or has no gap and already reads
clearly (the target agent could act on it as written), return it unchanged in a fenced block,
with one line saying it is already clear, and stop. A request with no gap that is disordered or
hard to follow goes on to step 3.

## 2. Ask, when only the user can answer

Ask about a gap only when the user alone can fill it: the why, the done-state, a preference.
Facts the target agent can look up (where code lives, how it works today, what a library
supports) stay with that agent. At most three questions, in plain chat text, numbered, each
short; then end your turn. With nothing to ask, go straight to step 3.

## 3. Write the prompt

Write in the user's voice: first person, their terms, their register. Keep every detail they
gave; add none of your own. Where their words are vague or a reference is ambiguous, keep their
wording rather than naming what they probably meant. Each gap they left unfilled, and anything
you had to assume, becomes an explicit open point, for example "I haven't decided how this should
look: propose two or three options before building."

Open with the task, then the four parts, in prose or short labelled lines, whichever reads closer
to how the user writes. Leave out a part that does not apply.

## 4. Hand it back

Reply with the prompt in a single fenced block, and nothing else.
