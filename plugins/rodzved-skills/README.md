# rodzved-skills

General-purpose skills, installed together as one plugin.

## delegate

A session mode for Claude Code that keeps the main session's context small. Once it is on, the
main session answers, decides and reviews, while subagents do the searching, planning and
execution. Long tool output stays in the subagents, so the main session lasts longer before you
have to clear it.

Use it for sessions with a lot of exploration or multi-step changes. A question Claude can answer
without tools, or a small edit at a known place, still happens in the main session.

### Use

| Installed as | Turn it on |
|---|---|
| Plugin | `/rodzved-skills:delegate` |
| Copied skill folder | `/delegate` |

Add a request after the command to start on it right away. Say "stop delegating" to end the mode.
After `/clear` or compaction, run the command again to restore it. The skill itself names
`/delegate`; with the plugin install, use `/rodzved-skills:delegate` if the bare name does not
resolve.

See the [root README](../../README.md#install) for both installs.

### Requirements

The skill expects access to the **Fable** and **Opus** models: it dispatches agents on `fable` and
`opus` (agent types `Explore` and `general-purpose`) and suggests `/model fable` for the main
session. On an account or provider without one of those models, its dispatches fail.

## mold

Rewrites a rough request into a prompt you paste into the session that does the work. A bare
"do X" makes an agent build X literally, even when something better exists; a reason alone lets
it reopen what you already decided. The skill sorts your text into four parts: the problem, the
outcome that shows it is solved, what is settled, and what is open for the agent to propose.

It asks at most three questions, only ones you alone can answer (the why, the done-state, a
preference), and leaves facts in the code to the agent. The one exception: when you ask it to
expand your wording and point at something in your project, it takes a brief read-only look at
that thing to name what is there, or asks you when it cannot find it. A gap you leave becomes an open point in
the prompt rather than a guess. It never starts the task itself. A request that is already clear
comes back unchanged.

### Use

Run it in a separate session from the one that will do the work.

| Installed as | Run it |
|---|---|
| Plugin | `/rodzved-skills:mold <rough idea>` |
| Copied skill folder | `/mold <rough idea>` |

Without an idea, it asks you to paste one. A command inside the idea, such as `/delegate`, stays
text in the prompt and is never run. To add a note, wrap the idea in quotes or a code fence and
put the note after it: instructions on how to rewrite are followed and left out of the prompt,
facts about the idea go into it. The answer is the prompt alone, in one fenced block,
in your own voice: plain sentences that lead with the problem and end with what is open, with no
headings or lists. Anything it had to assume is written into the prompt as an open point.

## Evals

The suite lives in [`evals/`](evals/), one folder per case.

| Case | What it checks |
|---|---|
| `hidden-design-choice` | A design choice found during planning comes back from a Fable planner as a question. |
| `mold-bare-request` | A bare "do X" with no why gets at most three questions, not the work itself. |
| `mold-expand-project` | An expand request that points at a project folder gets a brief read-only look, and a name found there reaches the prompt. |
| `mold-quoted-skill` | A quoted idea that opens with `/rodzved-skills:delegate` is rewritten, not run; the note after the quotes has its instruction left out of the prompt and its fact carried in. |
| `mold-rambling-request` | A rambling request that holds all four parts comes back rewritten as one fenced prompt, details kept and none added. |
| `mold-trivial-request` | A trivial rename comes back unchanged in a fenced block with a one-line note. |
| `no-tool-question` | A question answerable without tools stays in the main session. |
| `open-design-choice` | A design choice the user declares open comes back as scoped, well-formed questions. |
| `trace-unknown-path` | Exploration with no known target goes to an agent on Opus. |
| `typo-unknown-file` | A typo in an unknown file is found with one literal search and fixed inline. |
| `verify-auth-change` | A change that touches auth goes to a blind verifier before it is done. |

Run from the repository root:

```bash
bash plugins/rodzved-skills/eval.sh                                  # the whole suite
bash plugins/rodzved-skills/eval.sh --case 'no-tool-question' --runs 1  # one case, one run
```

- **Cost:** a run makes real model calls. On a Claude subscription it counts against your plan's
  usage limits and is not charged in dollars; with an API key it is billed. The script's
  `--max-cost-usd 10` caps the eval's estimate at API list prices, not plan usage.
- **Requirements:** Claude Code 2.1.269 or later, git 2.31 or later, [`uv`](https://docs.astral.sh/uv/)
  (one fixture's tests run through it), `bubblewrap` and `socat` on Linux. On Windows, run it in
  WSL2: native Windows has no sandbox backend.
- **Report:** `plugins/rodzved-skills/evals/results/<timestamp>/report.html`, ignored by git.
