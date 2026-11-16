# AGENTS.md

This repository is the shared agent "brain": standards, memory, plans, and
skills that get forked into other projects as `.opencode/`.

## What lives where

- `commands/*.md` — slash command definitions (source of truth). Keep each
  command self-contained: the model that runs it may be working in a project
  that pulled this brain in as `.opencode/`.
- `skills/<id>/SKILL.md` — agent skills. OpenCode auto-discovers
  `.opencode/skills/`; `scripts/install.sh` links this dir into other agents
  (e.g. `.claude/skills/`). Skill IDs are path-derived: directory name = ID.
- `templates/` — skeletons, currently just `AGENTS.md` for `/setup` output.
- `memory/` and `plans/` — follow their READMEs. Never put secrets in them.
- `scripts/` — small shell utilities; keep them POSIX `sh`, no external deps.

## Rules for editing this repo

- Every directory keeps a README with a "What's inside" table listing its
  files; update the table in the same change that adds or removes a file. Use
  `README.md`, except in `commands/` where it is named `README` so OpenCode
  does not register it as a `/README` command.
- READMEs document only; they never carry functional frontmatter, so agent
  discovery ignores them (a description-less `skills/README.md` is never
  advertised, and `install.sh` never links a README when merging item-level).

- Slash command changes must also work when the repo is imported: write paths
  as `<brain-relative>` and mention fallbacks for both layouts.
- Keep `commands/setup.md` and `skills/setup/SKILL.md` in sync: the skill's job
  is only to locate and hand off to the command spec.
- Adding an agent adapter (a new entry in `scripts/install.sh`'s `dirs_for`)
  requires updating README's sync-model section at the same time.
- Sync invariants (never break without changing `scripts/install.sh` + README
  together): `.opencode/` is the only place skills/commands are added; other
  agent dirs are symlink layers with relative targets; `.opencode/` is native
  to OpenCode and is never linked into itself.
- Be concrete; this repo exists to remove ambiguity for other agents.
