---
description: Interactive project setup — read the repo, ask questions, generate AGENTS.md
---

# /setup — Project bootstrap

Read this repository, ask the operator a few questions, then create or update
`AGENTS.md` at the repository root so every AI agent working here applies the
same standards.

The operator may pass extra arguments: treat them as hints or focus areas
(e.g. `/setup focus on the API layer`, `/setup re-run build commands`).

The agent brain lives in `commands/`'s parent directory: it is either this
repo's root (standalone brain) or `.opencode/` inside an importing project.

## Phase 1 — Read the repo (gather, don't question)

Collect these quietly with cheap parallel reads. Skip whatever does not exist —
absence is information, note it in the final `AGENTS.md` where relevant.

1. **Manifests** — `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`,
   `composer.json`, `Gemfile`, `pom.xml`, `*.csproj`, `pubspec.yaml`.
2. **Tooling & locks** — lockfiles; `.editorconfig`; formatter/linter configs
   (`.prettierrc*`, `eslint*`, `ruff.toml`, `biome.json`, `golangci.yml`, ...);
   `Makefile`, `justfile`, `docker-compose.yml`, `Dockerfile`.
3. **CI/CD** — `.github/workflows/*`, `.gitlab-ci.yml`, `.circleci/`.
4. **Existing docs & rules** — `README.md`, `CONTRIBUTING.md`, existing
   `AGENTS.md`, `CLAUDE.md`, `.cursor/rules`, `.windsurfrules`.
5. **Git signals** — `git log --oneline -30` for commit style, branch naming,
   and use of conventional commits.
6. **Structure** — top-level layout, monorepo workspaces, entry points,
   test locations.

Do not ask the operator anything Phase 1 can answer.

## Phase 2 — Ask (max 6 questions)

Ask only what the repo cannot answer. If the environment provides a structured
question tool (e.g. `question` / `AskUserQuestion`), use it with multiple-choice
options and a recommended first option; otherwise ask in chat in one batch.

Good questions, pruned to what's actually unknown:

1. **Confirmation** — summarize the stack, entry points, and monorepo layout you
   found; correct anything wrong or missing.
2. **Commands** — which build/dev/test/lint commands should agents run (only if
   not evident from manifests/CI/Makefile).
3. **Style hard rules** — anything beyond what formatters enforce: naming,
   module boundaries, doc requirements.
4. **Commit & PR conventions** — confirm what `git log` suggested, or state it.
5. **Forbidden things** — files/dirs agents must never touch, commands never to
   run, guardrails for destructive actions.
6. **Memory** — anything the operator always wants remembered (preferences,
   recurring tasks, personal context) → we'll store it in the brain's memory.
   `Other` option is always available.

## Phase 3 — Write AGENTS.md

Read the skeleton from the brain's `templates/AGENTS.md` (path is
`<brain>/templates/AGENTS.md` — try `.opencode/templates/AGENTS.md` and, as
fallback, `templates/AGENTS.md` relative to the current directory).

If an `AGENTS.md` already exists, **merge**: keep any existing rules or operator
content, correct stale facts, and use the skeleton's section order for anything
new. Never delete operator-authored rules without asking.

Requirements for the output:

- Written at the repository root as `AGENTS.md`.
- Concrete over generic: real commands found in manifests/CI, real paths.
- No placeholders or "<fill in>" text left behind.
- Includes a short **"Agent brain"** section pointing to the brain directories
  (memory/plans/skills — see template) so instructions about recording memory
  and plans carry into every project.
- Anything the operator answered that is personal (not project-specific) goes to
  memory, not into `AGENTS.md`.

## Phase 4 — Seed the brain

After writing `AGENTS.md`, ask (one final question):

1. **Memory**: store anything from the session in the brain? Target file:
   `<brain>/memory/YYYY-MM-DD-<short-slug>.md` (e.g. `2026-11-03-project-setup.md`),
   using the format described in the brain's `memory/README.md`. Skip secrets.
2. **Plan**: if the session surfaced upcoming work, offer to create a plan file
   in `<brain>/plans/` following its `README.md` format.

Report what you wrote and where. Done.
