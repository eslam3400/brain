# brain

Shared "brain" for AI coding agents. Pull this repo into any project, rename
the directory to `.agents/`, run the installer once, and every agent working
there inherits the same standards, memory, and skills.

## What's inside

| Directory          | Purpose                                                              |
| ------------------ | -------------------------------------------------------------------- |
| `commands/`        | Slash command specs (`/setup`, ...); symlinked into agents           |
| `skills/`          | Agent skills; OpenCode auto-discovers `.agents/skills/`              |
| `templates/`       | Skeletons `/setup` fills in for a project                            |
| `memory/`          | Durable facts, decisions, operator preferences                       |
| `plans/`           | Multi-step plans and handoffs between sessions                       |
| `scripts/`         | POSIX `sh` utilities; the symlink installer                          |

Every directory is documented in its own `README.md` — see the links above.
Root-level files: `AGENTS.md` (rules for maintaining the brain), `README.md`
(this file).

## Use it in a project

```sh
cd <project>
git clone <this-repo> /tmp/brain && rm -rf /tmp/brain/.git
mv /tmp/brain .agents

.agents/scripts/install.sh       # one-time: symlinks .opencode/commands, .opencode/agents
```

Then run `/setup` in OpenCode. It reads the repo, asks a short round of
questions, and generates `AGENTS.md` at the project root. Skills under
`.agents/skills/` are picked up automatically — nothing to configure.

From then on the brain travels with the project (or can be re-pulled to
update; keep operator-authored content in `memory/` when pulling updates).

## Sync model: the brain is the only place content is added

`.agents/` is the source of truth; each agent's convention directories become
thin symlink layers that never drift from it:

- **Add skills/commands only to `.agents/`**, never to `.opencode/` or
  `.claude/` directly. Commit the links (or just re-run `install.sh` after
  cloning), and every agent in the repo resolves the same content.
- **`install.sh` granularity**: on a fresh project the *whole directory* gets
  linked (`.opencode/commands -> ../.agents/commands`), so new brain files
  appear automatically with no reruns. If an agent already has its own
  directory, brain items are linked *into* it one-by-one, preserving local
  content — rerun the script after adding new brain items in that case.
  It is idempotent and can be rerun any time.
- **No duplicate discovery**: directories an agent natively reads from
  `.agents/` are deliberately not linked — e.g. OpenCode discovers
  `.agents/skills` itself, while Claude needs `.claude/skills` linked to it.
- **Relative link targets** survive moving or cloning the project.
- **New agents later**: extend the `dirs_for` table in `scripts/install.sh`
  and run `.agents/scripts/install.sh <agent>`. Known so far: `opencode`,
  `claude`.

One-off examples:

```sh
.agents/scripts/install.sh            # opencode only (default)
.agents/scripts/install.sh opencode claude
```
