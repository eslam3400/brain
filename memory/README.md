# Memory

Durable, project-specific knowledge agents should remember across sessions.
Small, dated, tagged files beat one growing dump.

## What's inside

| Entry | Content |
| ----- | ------- |
| `README.md` | This format guide — what belongs here, what does not |
| `YYYY-MM-DD-<short-slug>.md` | One topic per file; agent-written and operator-reviewed notes (created as needed) |

## File format

One file per topic, named `YYYY-MM-DD-<short-slug>.md`:

```markdown
---
date: 2026-11-03
project: <repo name>
tags: [preferences, workflow]
---

# <Title>

- <Fact / decision / preference, one bullet each.>
- <Keep it factual: what, why in one clause, no essays.>
```

## What belongs here

- Operator preferences (works similarly across projects): e.g. "always run
  tests before committing".
- Project decisions and their one-line rationale.
- Non-obvious facts learned the hard way (a script quirks, a flaky test).

## What does not belong here

- Secrets (tokens, keys, passwords) — never.
- Ephemeral session state — use `plans/`.
- Facts derivable from the repo itself — put them in `AGENTS.md` instead.

## Maintenance

- Before adding, skim existing files with the same tag; extend rather than duplicate.
- If a file only matters to one project, it still lives here during the fork;
  prune when it goes stale.
