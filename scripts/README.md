# scripts/

Small utilities for wiring the brain into projects. POSIX `sh`, no external
dependencies; any binary an action needs (e.g. `git`) must exist on the host.

## What's inside

| Script       | Purpose                                                                 |
| ------------ | ----------------------------------------------------------------------- |
| `install.sh` | Symlinks agent convention directories (`.opencode/commands`, `.opencode/agents`, `.claude/commands`, `.claude/skills`, ...) to the brain, so agent-facing layers always resolve brain content. Idempotent; run once per project. |

Usage, from the project root that owns `.agents/`:

```sh
.agents/scripts/install.sh                  # opencode (default)
.agents/scripts/install.sh opencode claude  # several agents at once
```

## Conventions

- New utilities get an entry in this table and a one-paragraph usage
  explanation above; keep each script runnable with plain `sh` (checked by
  `sh -n`).
- Agent registrations (directories per agent) live in `install.sh`'s
  `dirs_for` table — extend it when adding agents; update the root README's
  "Sync model" section in the same change.
