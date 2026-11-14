# skills

A collection of [Claude Code](https://code.claude.com/docs/en/overview) skills. Each skill is
packaged as its own plugin, so you install only the ones you want, and each can also be used as a
plain skill folder.

## Skills

| Skill | What it does |
|---|---|
| [`delegate`](plugins/delegate/README.md) | Session mode that keeps the main session's context small by sending search, planning and execution to subagents. |

## Install

### As a plugin (recommended)

```bash
claude plugin marketplace add rodzved/skills
claude plugin install delegate@rodzved-skills
```

Then, in a session: `/delegate:delegate`.

### As a plain skill

```bash
git clone https://github.com/rodzved/skills
cp -r skills/plugins/delegate/skills/delegate ~/.claude/skills/
```

Then, in a session: `/delegate`.

Copy the inner `plugins/<name>/skills/<name>` folder, which holds the `SKILL.md`; copying
`plugins/<name>` itself would load it as a plugin instead.

## Update and remove

| Install | Update | Remove |
|---|---|---|
| Plugin | `claude plugin update delegate@rodzved-skills` | `claude plugin uninstall delegate@rodzved-skills` |
| Plain skill | Copy the folder again | Delete `~/.claude/skills/delegate` |

## Evals

Each skill ships its eval suite next to it (`plugins/<name>/evals/`). The suites make real model
calls: about $6 a full run for `delegate` by the eval's estimate at API list prices, counted against
your plan's usage limits on a Claude subscription or billed with an API key. They need
`bubblewrap` and `socat` on Linux, and are not run in CI. See the
[delegate README](plugins/delegate/README.md#evals) for how to run them.

## Forks and issues

This is a skill I built and that I use. You're welcome to fork it, or to open an issue for an
improvement, but it won't be a priority for me, if ever.

## Licence

MIT, see [LICENSE](LICENSE).
