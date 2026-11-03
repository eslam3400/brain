---
name: Project Setup
description: Interactive repo bootstrap — reads the repository, asks the operator questions, and generates or updates AGENTS.md. Use when the operator says "setup", "/setup", or wants project standards captured.
---

Load and follow the full setup spec, then execute it.

1. Locate the setup spec file: it lives next to this skill's brain. Try, in order:
   - `.agents/commands/setup.md` (this repo is a project that imported the brain)
   - `commands/setup.md` (this repo is the standalone brain)
2. Read the entire spec file and treat its content as your instructions.
3. Execute it in the current session (do not spawn a subagent — you need to ask the operator questions).
