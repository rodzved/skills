# skills

A collection of [Claude Code](https://code.claude.com/docs/en/overview) skills, grouped into
plugins. Each skill can also be used as a plain skill folder.

## Skills

| Skill | Plugin | What it does |
|---|---|---|
| [`delegate`](plugins/rodzved-skills/README.md#delegate) | `rodzved-skills` | Session mode that keeps the main session's context small by sending search, planning and execution to subagents. |
| [`mold`](plugins/rodzved-skills/README.md#mold) | `rodzved-skills` | Rewrites a rough request into a prompt for a coding agent: the why, the done-state, what is settled and what is open. |

## Install

### As a plugin (recommended)

```bash
claude plugin marketplace add rodzved/skills
claude plugin install rodzved-skills@rodzved
```

Then, in a session: `/rodzved-skills:delegate`.

### As a plain skill

```bash
git clone https://github.com/rodzved/skills
cp -r skills/plugins/rodzved-skills/skills/delegate ~/.claude/skills/
```

Then, in a session: `/delegate`.

Copy the inner `plugins/<plugin>/skills/<skill>` folder, which holds the `SKILL.md`; copying
`plugins/<plugin>` itself would load it as a plugin instead.

## Update and remove

| Install | Update | Remove |
|---|---|---|
| Plugin | `claude plugin update rodzved-skills@rodzved` | `claude plugin uninstall rodzved-skills@rodzved` |
| Plain skill | Copy the folder again | Delete `~/.claude/skills/delegate` |

## Evals

Each plugin ships its eval suite next to its skills (`plugins/<plugin>/evals/`). The suites make
real model calls: about $6 for the `rodzved-skills` delegate cases by the eval's estimate at API
list prices (its mold cases are not costed yet), counted against your plan's usage limits on a
Claude subscription or billed with an API key. They need `bubblewrap` and `socat` on Linux, and are not run in CI. See the
[rodzved-skills README](plugins/rodzved-skills/README.md#evals) for how to run them.

## Forks and issues

This is a skill I built and that I use. You're welcome to fork it, or to open an issue for an
improvement, but it won't be a priority for me, if ever.

## Licence

MIT, see [LICENSE](LICENSE).
