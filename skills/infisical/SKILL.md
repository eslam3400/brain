---
name: Infisical
description: Wire a project to Infisical with a machine identity and a two-command Makefile (`make up`, `make local`), so secrets are injected at run time and never written to .env
---

# Infisical

## When to use

A project stores its secrets in Infisical and runs from a single host: a Docker
Compose stack, the same services on the host for development, or both. Goal: no
secrets on disk, no `env_file`, no helper scripts — just two commands.

## Target design

- `.env` holds only the machine-identity bootstrap values, mode `600`, gitignored.
- **One self-contained `Makefile`** owns the whole integration: it sources `.env`,
  mints one token and wraps the command in `infisical secrets-manager run`.
  No `scripts/` directory.
- **Two targets, no more:**
  - `make up` — the compose stack (`docker compose up -d`).
  - `make local` — the services on the host (the project's own dev command).
- Secrets are injected **once on the host**. Containers receive values from
  explicit `environment:` entries, because Compose never forwards the parent
  environment by itself and `env_file:` requires a file.

## Steps

1. In every compose file, replace `env_file: .env` on each service with an
   explicit `environment:` map containing only what that service needs, e.g.
   `POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}`.
2. Copy `templates/Makefile` to the repo root. Set `FILE` to the compose file and
   replace the `local` recipe body with the project's dev command(s) — one shell
   line, both services started in the background with `wait` if there are two.
   If the project has no host mode, delete `local` and keep `up`.
3. Copy the bootstrap block from `templates/env.example` into `.env.example`,
   leaving the project's real variable list below the divider as reference only.
4. Create `.env` from it, fill the `INFISICAL_*` values, `chmod 600 .env`, and
   confirm `.env` is in `.gitignore`.
5. Run `make local` (host) and `make up` (compose). A missing key surfaces as a
   compose warning plus a fail-fast boot error — add it to the service's
   `environment:` block, not to `.env`.

## Rules

- The Makefile sources `.env`, so it must stay bootstrap-only. Real secrets
  there are exported and shadow the injected values.
- Machine identities have no `.infisical.json`, so `--projectId` is required.
  `infisical run` also honours `INFISICAL_PROJECT_ID`, but pass the flag.
- Pass `--expand=false` to every fetch. The CLI expands `$VAR` inside secret
  values by default, so any secret containing `$` (JWT secret, SMTP password,
  bcrypt hash) is corrupted — and re-expanded at every nesting layer.
- Store values verbatim; a literal `$` needs no `$$` doubling. `$$` is only for
  literal text inside a compose file that Compose itself interpolates.
- Always go through `make` for anything that needs secrets; a bare
  `docker compose` starts without them. Plain commands are fine for `logs`,
  `down` and other operations that read no secrets.
- One token per target run (`BOOTSTRAP` mints it once and unsets the client
  secret). Raise the client secret's max uses, or the identity locks out under
  normal use.
- Two projects (a shared "infra" project plus an app project, app wins on
  duplicates)? Nest the fetches, infra first:
  ```make
  RUN = $(BOOTSTRAP) exec infisical secrets-manager run --projectId "$${INFISICAL_INFRA_PROJECT_ID}" ... -- \
        infisical secrets-manager run --projectId "$${INFISICAL_PROJECT_ID}" ... --
  ```
- Portainer git stacks cannot run the Makefile; deploy from the host CLI.
