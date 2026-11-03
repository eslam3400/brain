# commands/

Source of truth for slash commands. Files here are symlinked by
`scripts/install.sh` into each agent's command directory (e.g.
`.opencode/commands/` in OpenCode projects), so `/name` always resolves to the
brain's content.

## What's inside

| File       | Purpose                                                                 |
| ---------- | ----------------------------------------------------------------------- |
| `setup.md` | The `/setup` command — reads the repo, asks the operator questions, and generates or updates `AGENTS.md` |

Each `<name>.md` here becomes `/name` in connected agents. YAML frontmatter
fields (`description`, `agent`, `model`) are agent-specific; keep bodies
self-contained so they work when the brain is imported as `.agents/`.

## Conventions

- One command per file, `kebab-case` file name (`release-notes.md` → `/release-notes`).
- `$ARGUMENTS` carries what the operator types after the command name.
- Write paths as brain-relative with fallbacks (see root `AGENTS.md`).

Note: `README.md` in this directory is documentation; rerunning
`scripts/install.sh` in merge mode skips it so it never registers as a command.
