# delegate

A session mode for Claude Code that keeps the main session's context small. Once it is on, the
main session answers, decides and reviews, while subagents do the searching, planning and
execution. Long tool output stays in the subagents, so the main session lasts longer before you
have to clear it.

Use it for sessions with a lot of exploration or multi-step changes. A question Claude can answer
without tools, or a small edit at a known place, still happens in the main session.

## Use

| Installed as | Turn it on |
|---|---|
| Plugin | `/delegate:delegate` |
| Copied skill folder | `/delegate` |

Add a request after the command to start on it right away. Say "stop delegating" to end the mode.
After `/clear` or compaction, run the command again to restore it. The skill itself names
`/delegate`; with the plugin install, use `/delegate:delegate` if the bare name does not resolve.

See the [root README](../../README.md#install) for both installs.

## Requirements

The skill expects access to the **Fable** and **Opus** models: it dispatches agents on `fable` and
`opus` (agent types `Explore` and `general-purpose`) and suggests `/model fable` for the main
session. On an account or provider without one of those models, its dispatches fail.

## Evals

The suite lives in [`evals/`](evals/), one folder per case.

| Case | What it checks |
|---|---|
| `hidden-design-choice` | A design choice found during planning comes back from a Fable planner as a question. |
| `no-tool-question` | A question answerable without tools stays in the main session. |
| `open-design-choice` | A design choice the user declares open comes back as scoped, well-formed questions. |
| `trace-unknown-path` | Exploration with no known target goes to an agent on Opus. |
| `typo-unknown-file` | A typo in an unknown file is found with one literal search and fixed inline. |
| `verify-auth-change` | A change that touches auth goes to a blind verifier before it is done. |

Run from the repository root:

```bash
bash plugins/delegate/eval.sh                                  # the whole suite
bash plugins/delegate/eval.sh --case 'no-tool-question' --runs 1  # one case, one run
```

- **Cost:** a full run is about $6 by the eval's estimate at API list prices. On a Claude
  subscription it counts against your plan's usage limits and is not charged in dollars; with an
  API key it is billed. The script's `--max-cost-usd 10` caps that estimate, not plan usage.
- **Requirements:** Claude Code 2.1.269 or later, git 2.31 or later, [`uv`](https://docs.astral.sh/uv/)
  (one fixture's tests run through it), `bubblewrap` and `socat` on Linux. On Windows, run it in
  WSL2: native Windows has no sandbox backend.
- **Report:** `plugins/delegate/evals/results/<timestamp>/report.html`, ignored by git.
