# skills/

Agent skills: reusable instruction packs a coding agent loads on demand by ID.
OpenCode discovers `.agents/skills/` natively; `scripts/install.sh` links this
directory for agents that don't (e.g. Claude Code reads `.claude/skills/`).

## What's inside

| Skill    | Description                                                                  |
| -------- | ---------------------------------------------------------------------------- |
| `setup/` | Interactive repo bootstrap — reads the repository, asks the operator questions, and generates or updates `AGENTS.md` |

Each skill is a directory containing `SKILL.md` (frontmatter: `name`,
`description`) plus supporting files. The skill ID equals the directory name.

## Conventions

- Keep `SKILL.md` a trigger + workflow, with details in sibling files the skill
  tells the agent to read.
- A clear `description` in the frontmatter is what makes the model discover the
  skill; without it the skill is never advertised.
- `README.md` files (this one) hold directory docs; they carry no `description`,
  so they register inertly and are never advertised to models.
- Mirror command specs — `setup` skill just locates and hands off to
  `.agents/commands/setup.md`; see root `AGENTS.md` for the sync rule.
