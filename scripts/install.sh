#!/usr/bin/env sh
# Point coding agents at the brain with symlinks so .agents/ stays the single
# source of truth.
#
# Principle: add skills/commands only to the brain, never to .opencode/ or
# .claude/ directly. Run this script once per project, and again whenever new
# items are added below an agent's already-existing directory.
#
# Linking strategy per <agent>/<dir>:
# 1. Destination missing  -> symlink the whole brain directory. Everything you
#    add to the brain shows up in the agent automatically, no reruns.
# 2. Destination exists   -> symlink each brain item into it instead, so agent
#    -local content survives. Rerun this script after adding new brain items.
# 3. Destination exists but is a plain file -> skipped with a warning.
# Dirs an agent discovers natively under .agents/ (OpenCode reads .agents/skills
# directly) are deliberately NOT linked, to avoid duplicate registrations.
#
# All symlink targets are relative, so moved or cloned projects keep working.
#
# Usage, from the project root that owns the brain:
#   .agents/scripts/install.sh                  # opencode (default)
#   .agents/scripts/install.sh opencode claude  # several agents at once
set -eu

BRAIN="$(cd "$(dirname "$0")/.." && pwd)"
BRAIN_NAME="$(basename "$BRAIN")"
AGENTS="${*:-opencode}"

link_dir() { # $1 = agent dir pair "<agent-root>/<dir>", e.g. .opencode/commands
  dest="$1"
  name="$(basename "$dest")"
  mid="$(dirname "$dest")"
  src="$BRAIN/$name"
  if [ ! -d "$src" ]; then
    printf '  skip     %s (nothing named %s in the brain)\n' "$dest" "$name"
    return 0
  fi
  dir_rel="../$BRAIN_NAME/$name"

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$dir_rel" ]; then
      printf '  ok       %s -> %s (already linked)\n' "$dest" "$dir_rel"
    else
      printf '  replace  %s (was linked to %s)\n' "$dest" "$(readlink "$dest")"
      ln -sfn "$dir_rel" "$dest"
      printf '  ok       %s -> %s\n' "$dest" "$dir_rel"
    fi
  elif [ -d "$dest" ]; then
    mkdir -p "$dest"
    printf '  merge    %s exists; linking brain items into it\n' "$dest"
    for item in "$src"/* "$src"/.[!.]*; do
      [ -e "$item" ] || continue
      if [ "$(basename "$item")" = "README.md" ]; then
        printf '  skip     %s (directory docs, not functional)\n' "$(basename "$item")"
        continue
      fi
      item_rel="../../$BRAIN_NAME/$name/$(basename "$item")"
      if ln -sfn "$item_rel" "$dest/$(basename "$item")"; then
        printf '  ok       %s -> %s\n' \
          "$dest/$(basename "$item")" "$item_rel"
      else
        printf '  skip     %s (link target clashes with existing file)\n' \
          "$dest/$(basename "$item")"
      fi
    done
  elif [ -e "$dest" ]; then
    printf '  skip     %s exists as a plain file — resolve by hand\n' "$dest"
  else
    mkdir -p "$mid"
    ln -sfn "$dir_rel" "$dest"
    printf '  ok       %s -> %s\n' "$dest" "$dir_rel"
  fi
}

dirs_for() {
  case "$1" in
    # skills and agents: OpenCode discovers .agents/skills itself; other trees
    # (slash commands, file-based agents) are not read from .agents/.
    # commands ::= .opencode/commands
    # agents   ::= .opencode/agents
    opencode) printf '.opencode/commands\n.opencode/agents\n' ;;
    # Claude Code does not read the .agents tree at all.
    claude) printf '.claude/commands\n.claude/skills\n' ;;
    *)
      printf 'install.sh: unknown agent "%s"\n(known: opencode, claude — extend dirs_for to add more)\n' "$1" >&2
      exit 2
      ;;
  esac
}

for agent in $AGENTS; do
  printf 'agent: %s\n' "$agent"
  dirs_for "$agent" | while IFS= read -r dest; do
    link_dir "$dest"
  done
  echo "  done"
done

echo
echo "Done. OpenCode hot-reloads commands and agents; new skills are usable"
echo "immediately. Rerun this script after adding content under an agent dir"
echo "that already existed on disk (case 2 above)."
