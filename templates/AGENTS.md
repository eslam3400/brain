# <Project Name>

<!-- Skeleton for /setup output. Replace every placeholder; delete sections
     that genuinely do not apply — never leave "<>" text behind. -->

## Overview

<Approximately 2–4 sentences here: what this project is, who it serves, and how the code is organized (monorepo workspaces, main packages, entry points).>

## Stack

| Concern  | Choice                      |
| -------- | --------------------------- |
| Language | <e.g. TypeScript 6, Node 24> |
| Runtime  | <e.g. Node, pnpm>           |
| Framework| <e.g. Next.js>              |
| Database | <e.g. PostgreSQL>           |
| Testing  | <e.g. Vitest>               |

## Common commands

<Only real commands found in manifests, CI, Makefile, or confirmed by the operator.>

```sh
# Install dependencies
<command>

# Dev server
<command>

# Tests (all)
<command>

# Single test
<command path/to/file.test.ts>

# Lint / format
<command>
```

## Code style

<Formatter-config-driven facts plus the operator's hard rules.>

- <e.g. Prettier with defaults; run on save, do not hand-format.>
- <Naming, module boundaries, error handling conventions.>
- <Doc requirements: e.g. exported functions get TSDoc.>

## Architecture notes

<Key invariants that span files: request flow, data ownership, boundaries
between layers, generated code that must not be hand-edited.>

## Git conventions

- <e.g. Conventional Commits; imperative subject, ≤72 chars.>
- <e.g. Branches: `feat/<short-name>`; main is squash-merged.>
- <e.g. Every PR needs tests for changed behavior.>

## Testing

<Where tests live, what to cover, fastest command to run.>

## Boundaries (never do this)

- <e.g. Never edit `.env*`, `dist/`, or generated `src/api/generated/`.>
- <e.g. Never run `git push` without explicit approval.>

## Agent brain

This project imports the agent brain at `.opencode/`. When it pays to remember
or plan (non-obvious learnings, operator preferences, multi-step work), write to:

- `.opencode/memory/YYYY-MM-DD-<short-slug>.md` — durable facts and learnings.
- `.opencode/plans/<name>.md` — plans and roadmaps.

Cease writing there if asked; secrets never go in these files.
