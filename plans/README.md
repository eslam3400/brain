# Plans

Multi-step work: roadmaps, refactors, migrations, anything spanning more than
one session.

## What's inside

| Entry | Content |
| ----- | ------- |
| `README.md` | This format guide |
| `<short-name>.md` | One active plan per file; `status` marks draft / in-progress / blocked / done (created as needed) |

## File format

One plan per file, named `<short-name>.md`:

```markdown
---
created: 2026-11-03
status: in-progress          # draft | in-progress | blocked | done
project: <repo name>
---

# <Goal>

## Context

<Why this work. In one or two paragraphs.>

## Steps

- [ ] 1. <Step>
- [ ] 2. <Step> — depends on 1

## Handoff

<Notes the next session needs: what state is the repo in, what was decided.>
```

## Rules

- Keep steps small enough to finish in one sitting; agents check off progress
  as they go so another session can pick it up.
- When a plan finishes: mark steps, set `status: done`, and move durable
  learnings to `../memory/`.
