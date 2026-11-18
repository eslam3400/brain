# brain

Shared "brain" for AI coding agents. Pull this repo into any project as
`.opencode/` and OpenCode picks it up with no configuration: commands, skills,
memory, and plans travel with the project.

## What's inside

| Directory          | Purpose                                                              |
| ------------------ | -------------------------------------------------------------------- |
| `commands/`        | Slash command specs (`/setup`, ...); OpenCode discovers `.opencode/commands/` |
| `skills/`          | Agent skills; OpenCode auto-discovers `.opencode/skills/`            |
| `templates/`       | Skeletons `/setup` fills in for a project                            |
| `memory/`          | Durable facts, decisions, operator preferences                       |
| `plans/`           | Multi-step plans and handoffs between sessions                       |
| `scripts/`         | POSIX `sh` utilities; symlink installer for non-OpenCode agents      |

Every directory is documented in its own README — see the links above.
Root-level files: `AGENTS.md` (rules for maintaining the brain), `README.md`
(this file), `.gitignore`, and an untracked `.env` (operator secrets — see
[shared `.env`](#sync-model-the-brain-is-the-only-place-content-is-added)).

## Use it in a project

```sh
cd <project>
git clone <this-repo> /tmp/brain && rm -rf /tmp/brain/.git
mv /tmp/brain .opencode
```

That is the whole OpenCode setup: no `opencode.json`, no installer. Then run
`/setup` in OpenCode. It reads the repo, asks a short round of questions, and
generates `AGENTS.md` at the project root. Skills under `.opencode/skills/` and
commands under `.opencode/commands/` are picked up automatically.

From then on the brain travels with the project (or can be re-pulled to
update; keep operator-authored content in `memory/` when pulling updates).

## Sync model: the brain is the only place content is added

`.opencode/` is the source of truth. OpenCode reads it natively, so it needs no
symlink layer; other agents get thin links that never drift:

- **Add skills/commands only to `.opencode/`**, never to `.claude/` or another
  agent's directory directly. Commit the links (or just re-run `install.sh`
  after cloning), and every agent in the repo resolves the same content.
- **OpenCode needs no links**: it discovers `.opencode/commands/`,
  `.opencode/skills/`, and `.opencode/agents/` itself.
- **`install.sh` granularity**: for another agent, on a fresh project the
  *whole directory* gets linked (`.claude/commands -> ../.opencode/commands`),
  so new brain files appear automatically with no reruns. If an agent already
  has its own directory, brain items are linked *into* it one-by-one,
  preserving local content — rerun the script after adding new brain items in
  that case. It is idempotent and can be rerun any time.
- **Relative link targets** survive moving or cloning the project.
- **Shared `.env`**: the standalone brain keeps one `.env` (gitignored, mode
  `600`) holding only the bootstrap values every project needs — the Infisical
  machine identity and Compose defaults. `/setup` runs `scripts/link-env.sh`,
  which points every sibling git repo's `.env` at it
  (`<project>/.env -> ../brain/.env`) and replaces any existing `.env`, so
  rotating a value in the brain updates all projects at once. Imported brains
  (`.opencode/`) never link across projects: the host project owns its `.env`.
- **New agents later**: extend the `dirs_for` table in `scripts/install.sh`
  and run `.opencode/scripts/install.sh <agent>`. Known so far: `opencode`
  (native, no links) and `claude`.

One-off examples:

```sh
.opencode/scripts/install.sh            # opencode: native, links nothing
.opencode/scripts/install.sh claude     # links .claude/commands and .claude/skills
```
