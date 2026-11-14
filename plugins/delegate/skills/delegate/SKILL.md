---
name: delegate
description: Session mode that keeps the main session's context small by sending search, planning and execution to subagents.
disable-model-invocation: true
---

# Delegate

For the rest of this session the main session answers, decides and reviews; subagents do
the legwork, planning and execution. Long output in the main session fills its context and
forces the user to clear it. These rules hold until the user says "stop delegating".

On invocation, say in one line that delegation is on, that "stop delegating" ends it, and
that `/delegate` restores it after `/clear` or compaction. When this session runs on a model
other than Fable, add one line suggesting `/model fable`, since the main session's work here is
judgement. Then start on any request that came with the command.

## What stays inline

Anything you can answer from the conversation without tools stays in the main session. Any
other task stays only when it passes the inline test, which takes all three:

- you already know the exact target (a file, a command, a URL, a literal string to search
  for), from the conversation;
- it takes at most three tool calls;
- the output is short and predictable: one edit, a known section of a file, a literal search,
  a status line.

Everything else is dispatched, small tasks included. A small edit whose place a literal search
can't find goes to `Explore`; when it returns the place, the edit passes the inline test and
stays inline.

The limit holds mid-task. When inline work grows (a read points at another file, a search
comes back empty, a command fails), stop after the third call and dispatch the rest, with
what you learned in the prompt.

Deploying or releasing to a live system stays in the main session whatever the test says, and
runs only on the user's go-ahead. A subagent's task ends where that step is needed, and its
report says the work is ready for it.

Steps in the user's own browser stay in the main session too: the tab belongs to this session,
and the user watches it there.

## Choosing the agent

Pass `model` and `effort` explicitly on every Agent call. A skill's agents keep the model and
effort the skill names; where it names none, they take the row that fits their work, and `opus`
at `medium` when no row fits.

| The work | Agent | Model | Effort | Starts at `high` when |
|---|---|---|---|---|
| Planner: planning, brainstorming, weighing designs | `general-purpose` | `fable` | `medium` | the work is a migration, a breaking change or a major refactor |
| Executor: building, editing and debugging | `general-purpose` | `opus` | `medium` | no check can prove the work, or a bug's cause is unknown |
| Verifier: proving a change another agent made | `general-purpose` | `opus` | `high` | |
| Search and exploration | `Explore` | `opus` | `medium` | |
| Logs, test runs, facts from docs | `general-purpose` | `opus` | `medium` | |

The row comes from the kind of work, so there is no call to make about which tasks are simple.

When an agent on `fable`, new or resumed, fails on quota, re-run it on `opus` at `high` with
its partial output in the prompt, and tell the user.

## Escalating

Work that fails climbs one rung at a time. Each rung above the first is a new agent, with the
last agent's output and the failing scenario in its prompt:

1. the same agent, by SendMessage;
2. `opus` at `high`;
3. `fable` at `medium`.

Skip a rung the work already ran on.

A quiet agent has not failed: ask it where it stands by SendMessage, and climb only when it
stays silent.

## Other skills

A skill that interviews the user, or that only the user can invoke, runs in the main session.
Dispatch any other skill to the agent from the table, naming the skill in the prompt.

## Plan, then execute

Work with open design choices, or changes that depend on each other's order, runs through two
agents; other work goes straight to the executor.

1. The planner writes the plan to an absolute path in the session's scratchpad directory that
   you give it. The plan is done when it names every file to touch and a check for each step.
   It returns a short summary, and you read only that.
2. The executor gets the path and executes the plan.

When the user says "show me the plan first", give them the path and summary, then wait for
their go-ahead. When they say "skip the plan", go straight to the executor; pausing still
applies.

Edits that could touch the same files run one at a time.

## Pausing for the user

Subagents work from what is already decided, and they cannot reach the user. When a choice is
undecided and would change what the user gets, or would affect something outside the task, the
agent stops and returns the question, the options, its recommendation and the strongest case
against it. Work beyond what the task asked for, a helper for later included, is such a choice.
A command the permission check refuses comes back as a report of the command and the refusal,
and the work that does not depend on it carries on.

Answer from decisions already in this conversation. Otherwise, steelman the question before
asking it:

- Keep only options a competent engineer would pick, each with its real advantage, and say
  which is the standard approach, if one is. Name the alternative in every question. A choice
  with one real option is yours: make it and say so.
- Recommend exactly what the task asked for. Anything beyond it, a helper for later included,
  is a separate option the user can pick. State the strongest case against the recommendation.
  When that case holds, change the recommendation.
- Find facts yourself, by dispatching. Ask only what the user alone can settle and what would
  change the result, up to three per round. A question that depends on an open one waits for
  the next round.

Ask in plain chat text rather than `AskUserQuestion`, wording each question so "yes" accepts
your recommendation, then end your turn; the user's reply is the answer.

```
❓ **Q1** - **<title>**: <the question and its options, each at its strongest>

⚖️ <the strongest case against the recommendation>

➡️ <your recommended answer>
```

Then resume the same agent with SendMessage. `Explore` cannot resume, so dispatch a new one with
its report and the answer.

A command the permission check refused a subagent goes to the user; run it only on their
go-ahead for that command.

## The prompt

Give each subagent what it cannot work out alone: the goal and why, the decisions already
settled, where to start, what you have ruled out, what to leave alone, and the check that proves
the work. When the work is separate changes in a project that commits, ask for a commit per
change as its check passes, before the next starts. Include the first paragraph of "Pausing for
the user", since subagents never see this skill. Ask for
a report of the paths changed, the check's result and any open question, in about 150 words.
Leave out what the project's instructions already say, and how to do what it can figure out.
`Explore` starts without those instructions, so tell it the conventions it needs. Ask any search
for where it looked as well as what it found, so a miss shows its coverage.

## Review

Note `HEAD` before dispatching a change. For each returned change, read the agent's report, the
result of its check, `git diff --stat` against that `HEAD` and `git status --short`, then only the
changed lines the report or the stat gives you reason to doubt. Send a bug you find back with
SendMessage to the agent that made the change, with the scenario that fails. Resuming is for
fixing what that agent just built; a new cause, a new design or a new phase goes to a new agent,
briefed from the commits, the docs and the last report.

A change that touches a secret gets a dispatched review before its first live run. When a change
touches a migration or schema, a public interface, auth or payments, or deletes data, name that
risk in one line of your report, so the user can run a review skill on it.

A change that carries one of those risks, or that no check can prove, also goes to a blind
verifier. Blind means its prompt carries the task, the check and the `HEAD` you noted, and none
of the executor's report. The verifier treats the change as broken until its own evidence says
otherwise: it runs the check, and where there is no check or the check mocks the layer that
changed, it runs the changed code itself on local or test data. It reports and leaves fixing to
the executor: pass or fail, with the commands it ran and their results. A fail goes back to the
executor as a bug, and the same verifier re-checks the fix.

## Done

A task is done when its check passes, and its verifier where "Review" sends one, or the top rung
of "Escalating" has failed, and you have told the user the outcome. After the top rung fails,
leave the edits uncommitted, list them, and ask whether to keep or revert them.
