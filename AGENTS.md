# AGENTS.md

This repository is the shared agent "brain": standards, memory, plans, and
skills that get forked into other projects as `.agents/`.

## What lives where

- `commands/*.md` — slash command definitions (source of truth). Keep each
  command self-contained: the model that runs it may be working in a project
  that pulled this brain in as `.agents/`.
- `skills/<id>/SKILL.md` — agent skills. OpenCode auto-discovers
  `.agents/skills/`; `scripts/install.sh` links this dir for agents that don't.
  Skill IDs are path-derived: directory name = ID.
- `templates/` — skeletons, currently just `AGENTS.md` for `/setup` output.
- `memory/` and `plans/` — follow their READMEs. Never put secrets in them.
- `scripts/` — small shell utilities; keep them POSIX `sh`, no external deps.

## Rules for editing this repo

- Every directory keeps a `README.md` with a "What's inside" table listing its
  files; update the table in the same change that adds or removes a file.
- READMEs document only; they never carry functional frontmatter, so agent
  discovery ignores them (a description-less `skills/README.md` is never
  advertised, and `install.sh` never links `README.md` when merging item-level).

- Slash command changes must also work when the repo is imported: write paths
  as `<brain-relative>` and mention fallbacks for both layouts.
- Keep `commands/setup.md` and `skills/setup/SKILL.md` in sync: the skill's job
  is only to locate and hand off to the command spec.
- Adding an agent adapter (a new entry in `scripts/install.sh`'s `dirs_for`)
  requires updating README's sync-model section at the same time.
- Sync invariants (never break without changing `scripts/install.sh` + README
  together): `.agents/` is the only place skills/commands are added; agent
  dirs are symlink layers with relative targets; dirs an agent natively reads
  from `.agents/` are never double-linked.
- Be concrete; this repo exists to remove ambiguity for other agents.
