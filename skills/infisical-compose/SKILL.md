---
name: Infisical Compose Secrets
description: Wire a Docker Compose project to Infisical with a machine identity and a Makefile, so secrets are injected at run time and never written to .env
---

# Infisical Compose Secrets

## When to use

A Docker Compose project stores its secrets in Infisical and is deployed
unattended on a single host. Goal: no secrets on disk, no `env_file`.

## Target design

- `.env` holds only machine-identity bootstrap values, mode `600`, gitignored.
- `infisical run` injects all project secrets into the `docker compose` process.
- Containers receive values from explicit `environment:` entries, because
  Compose never forwards the parent environment by itself and `env_file:`
  requires a file.

## Steps

1. In every compose file, replace `env_file: .env` on each service with an
   explicit `environment:` map containing only what that service needs, e.g.
   `POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}`.
2. Copy `templates/Makefile` to the repo root.
3. Copy the bootstrap block from `templates/env.example` into `.env.example`,
   leaving the project's real variable list below the divider as reference only.
4. Create `.env` from it, fill the `INFISICAL_*` values, `chmod 600 .env`, and
   confirm `.env` is in `.gitignore`.
5. Verify without Docker: `make verify` (add `SECRETS="A B"` to check other
   keys). On a host with Docker, also run `make config | grep <setting>` and
   then `make up`.

## Rules

- The Makefile sources `.env`, so it must stay bootstrap-only. Real secrets
  there are exported and shadow the injected values.
- Machine identities have no `.infisical.json`, so `--projectId` is required.
- Injected values are not re-interpolated: store `$` literally, no `$$`
  doubling. (Values read from `.env` by Compose do need `$$`.)
- Always go through `make`; a bare `docker compose` starts without secrets.
- Each target mints a fresh token. Raise the client secret's max uses, or the
  identity will lock out under normal use.
- Portainer git stacks cannot run the Makefile; deploy from the host CLI.
