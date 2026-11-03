# templates/

Starting skeletons that agent routines fill in. Nothing here is loaded
automatically; commands and skills reference them deliberately.

## What's inside

| File         | Used by    | Purpose                                                     |
| ------------ | ---------- | ----------------------------------------------------------- |
| `AGENTS.md`  | `/setup`   | Skeleton for a project's `AGENTS.md`: overview, stack, commands, style, architecture, git conventions, testing, boundaries, and a pointer to the agent brain |

## Conventions

- Placeholders look like `<placeholder>`; consumers must replace or drop every
  one — no `<text>` ever ships in output.
- Keep skeletons agent-agnostic: structure applies to any coding agent.
- Run `/setup` inside the standalone brain repo to fill a skeleton in place.
