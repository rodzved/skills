# skills

Public repo of Claude Code skills, one plugin per skill. The root is the plugin marketplace
`rodzved-skills`; each skill lives in `plugins/<name>/` with its manifest, `README.md`,
`skills/<name>/SKILL.md`, and an optional paid eval suite (`evals/` + `eval.sh`).

## Shipping

Every commit to `main` ships: people who installed a plugin get it at their next
`claude plugin update`. `plugin.json` stays version-free to keep it that way.

## Checks

Run `bash tests/run.sh` after every change; it is green when it exits 0. CI runs the same four
checks. Locally it skips a check whose tool (`shellcheck`, `claude`) is missing, and a skip is
not a pass.

## Evals

- `plugins/<name>/eval.sh` is paid: run it only when the user asks, one case first
  (`--case '<name>' --runs 1`). Commands, cost and requirements:
  [plugins/delegate/README.md#evals](plugins/delegate/README.md#evals).
- Results land in `evals/results/` and stay local (gitignored): transcripts carry local paths and
  session ids.
- A case is a folder; `tests/eval-cases.sh` enforces its shape:

  ```
  <case>/
  ├── prompt.md     starts with /<plugin>:<skill>, after frontmatter (description, max_turns, allowed_tools)
  ├── case.yaml     optional: schema_version "1.1", name, scaffold_script
  ├── fixture.sh    optional: bash that builds the whole repo the case runs in
  └── graders/*.md  one or more, each with `type:` in its frontmatter
  ```

- Graders: reach for `regex` and `tool_used` first; they need no judge model.

## Adding a skill

1. Create `plugins/<name>/` as above.
2. Add its entry to `.claude-plugin/marketplace.json` with `"source": "./plugins/<name>"`.
3. Add its row to the skills table in `README.md`.

The folder, the marketplace entry and `name` in `plugin.json` are one string. Done when
`bash tests/run.sh` is green.

## Conventions

- Shell is bash that runs unchanged in Git Bash on Windows; Python runs through `uv`; LF endings.
- Conventional Commits: subject at most 72 characters, the why in the body.
- Public repo: names, paths and emails in any file are placeholders.
