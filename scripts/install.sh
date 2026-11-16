#!/usr/bin/env sh
# Point non-OpenCode agents at the brain with symlinks so .opencode/ stays the
# single source of truth. OpenCode needs no links: it reads .opencode/commands,
# .opencode/skills, and .opencode/agents directly.
#
# Principle: add skills/commands only to the brain, never to .claude/ or any
# other agent directory directly. Run this script once per project, and again
# whenever new items are added below an agent's already-existing directory.
#
# Linking strategy per <agent>/<dir>:
# 1. Destination missing  -> symlink the whole brain directory. Everything you
#    add to the brain shows up in the agent automatically, no reruns.
# 2. Destination exists   -> symlink each brain item into it instead, so agent
#    -local content survives. Rerun this script after adding new brain items.
# 3. Destination exists but is a plain file -> skipped with a warning.
# OpenCode reads .opencode/* natively, so it is never linked to itself.
#
# All symlink targets are relative, so moved or cloned projects keep working.
#
# Usage, from the project root that owns the brain:
#   .opencode/scripts/install.sh                  # opencode: native, no links
#   .opencode/scripts/install.sh claude           # links .claude/
#   .opencode/scripts/install.sh opencode claude  # several agents at once
set -eu

BRAIN="$(cd "$(dirname "$0")/.." && pwd)"
BRAIN_NAME="$(basename "$BRAIN")"
AGENTS="${*:-opencode}"

link_dir() { # $1 = agent dir pair "<agent-root>/<dir>", e.g. .claude/commands
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
      case "$(basename "$item")" in
        README|README.md)
          printf '  skip     %s (directory docs, not functional)\n' "$(basename "$item")"
          continue
          ;;
      esac
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
    # OpenCode reads .opencode/{commands,skills,agents} natively; there is
    # nothing to link, and linking the brain to itself would recurse.
    opencode) ;;
    # Claude Code does not read the .opencode tree at all.
    claude) printf '.claude/commands\n.claude/skills\n' ;;
    *)
      printf 'install.sh: unknown agent "%s"\n(known: opencode, claude — extend dirs_for to add more)\n' "$1" >&2
      exit 2
      ;;
  esac
}

for agent in $AGENTS; do
  printf 'agent: %s\n' "$agent"
  dirs="$(dirs_for "$agent")"
  if [ -z "$dirs" ]; then
    printf '  native   OpenCode discovers .opencode/commands, .opencode/skills, and .opencode/agents directly; nothing to link\n'
  else
    printf '%s\n' "$dirs" | while IFS= read -r dest; do
      link_dir "$dest"
    done
  fi
  echo "  done"
done

echo
echo "Done. OpenCode hot-reloads commands, agents, and skills from .opencode/."
echo "Rerun this script after adding content under an adapter dir that already"
echo "existed on disk (case 2 above)."
