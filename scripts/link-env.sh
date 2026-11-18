#!/usr/bin/env sh
# Fan the brain's operator .env out to every sibling project as a relative
# symlink, so one file drives all of them: rotate the Infisical machine
# identity (or any compose default) in the brain and every project sees it.
#
# Scope: the standalone layout, where <parent>/brain sits next to
# <parent>/<project> directories. When the brain is imported into a project as
# .opencode/ or .agents/, its parent *is* that project and the project owns its
# own .env, so this script reports that and does nothing.
#
# Each sibling git repo gets <project>/.env -> ../<brain-name>/.env. An
# existing .env is replaced (real file or stale link) — the brain file is the
# source of truth. Non-git siblings, hidden dirs, and a .env that is itself a
# directory are never touched.
#
# Usage, any time (idempotent):
#   <brain>/scripts/link-env.sh
set -eu

BRAIN="$(cd "$(dirname "$0")/.." && pwd)"
BRAIN_NAME="$(basename "$BRAIN")"
BRAIN_ENV="$BRAIN/.env"
LINK_TARGET="$BRAIN_NAME/.env"

if [ ! -f "$BRAIN_ENV" ]; then
  printf 'link-env.sh: no %s — nothing to link\n' "$BRAIN_ENV"
  exit 0
fi

case "$BRAIN_NAME" in
  .*)
    printf 'link-env.sh: brain is imported as "%s"; the host project owns its .env — nothing to link\n' \
      "$BRAIN_NAME"
    exit 0
    ;;
esac

# Machine-identity bootstrap only; keep it unreadable to other users.
chmod 600 "$BRAIN_ENV"

PARENT="$(dirname "$BRAIN")"
linked=0
replaced=0
skipped=0

for project in "$PARENT"/*/; do
  project="${project%/}"
  [ -d "$project" ] || continue
  [ "$(cd "$project" && pwd -P)" = "$(cd "$BRAIN" && pwd -P)" ] && continue
  # Projects are the sibling git repos; plain files and loose dirs are not.
  [ -e "$project/.git" ] || continue

  name="$(basename "$project")"
  dest="$project/.env"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$LINK_TARGET" ]; then
    printf '  ok       %-14s .env already linked\n' "$name"
  elif [ -d "$dest" ]; then
    printf '  skip     %-14s .env is a directory — resolve by hand\n' "$name"
    skipped=$((skipped + 1))
  else
    existed=0
    if [ -e "$dest" ] || [ -L "$dest" ]; then existed=1; fi
    rm -f "$dest"
    ln -s "$LINK_TARGET" "$dest"
    if [ "$existed" -eq 1 ]; then
      printf '  replace  %-14s .env -> %s\n' "$name" "$LINK_TARGET"
      replaced=$((replaced + 1))
    else
      printf '  link     %-14s .env -> %s\n' "$name" "$LINK_TARGET"
      linked=$((linked + 1))
    fi
  fi
done

printf '\nDone: %d linked, %d replaced, %d skipped.\n' "$linked" "$replaced" "$skipped"
