# Two entry points: `make local` runs the services on the host, `make up` runs
# the compose stack. Both source .env (machine-identity bootstrap only), mint
# one token, and run the command inside the Infisical fetch. Containers never
# talk to Infisical; compose forwards only the vars listed in its
# `environment:` blocks.
#
# .env must be bootstrap-only and mode 600.

SHELL := /bin/sh

FILE ?= compose.yaml
ENV  ?= dev

# Load .env (bootstrap only), require the project ID, exchange the machine
# identity for a short-lived token, then drop the long-lived client secret.
BOOTSTRAP = set -eu; \
	if [ -f .env ]; then set -a; . ./.env; set +a; fi; \
	: "$${INFISICAL_PROJECT_ID:?INFISICAL_PROJECT_ID is not set}"; \
	if [ -z "$${INFISICAL_TOKEN:-}" ]; then \
	  INFISICAL_TOKEN=$$(infisical login --method=universal-auth --silent --plain); \
	fi; \
	export INFISICAL_TOKEN; \
	unset INFISICAL_UNIVERSAL_AUTH_CLIENT_ID INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET;

# --expand=false: the CLI expands `$VAR` inside a secret by default, and each
# nesting layer would expand again.
RUN = $(BOOTSTRAP) exec infisical secrets-manager run --projectId "$${INFISICAL_PROJECT_ID}" --env "$(ENV)" --path / --expand=false --silent --

.DEFAULT_GOAL := local
.PHONY: local up

# Replace with the project's dev command(s). One service:
#   @$(RUN) npm --prefix apps/api run start:dev
# Two services: start both in the background, then wait.
local:
	@$(RUN) <dev command>

up:
	@$(RUN) docker compose -f $(FILE) up -d
