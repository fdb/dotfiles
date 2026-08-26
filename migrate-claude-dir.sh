#!/bin/bash
# One-time migration: turn ~/.claude from a symlink into ~/dotfiles/claude
# into a real directory that holds Claude Code's live state locally, with
# only the versioned files symlinked back into the repo.
#
# Before:  ~/.claude -> ~/dotfiles/claude   (credentials + sessions inside a
#                                            public repo checkout, guarded
#                                            only by a .gitignore)
# After:   ~/.claude/                         (real dir, local state)
#            settings.json -> ~/dotfiles/claude/settings.json
#            CLAUDE.md     -> ~/dotfiles/agents/AGENTS.md
#            skills        -> ~/dotfiles/agents/skills
#
# Safe to re-run: does nothing if ~/.claude is already a real directory.
# Best run while Claude Code is not running.
set -euo pipefail

DOTFILES="$HOME/dotfiles"
REPO_CLAUDE="$DOTFILES/claude"
LIVE="$HOME/.claude"

if [ ! -L "$LIVE" ]; then
  if [ -d "$LIVE" ]; then
    echo "~/.claude is already a real directory — nothing to migrate."
  else
    echo "~/.claude does not exist — nothing to migrate."
  fi
  echo "Re-running install.sh to make sure the symlinks are in place."
  "$DOTFILES/install.sh"
  exit 0
fi

# Refuse to touch a symlink that points somewhere we don't expect.
if [ "$(cd -P "$LIVE" && pwd)" != "$(cd -P "$REPO_CLAUDE" && pwd)" ]; then
  echo "ERROR: ~/.claude is a symlink to '$(readlink "$LIVE")', not to $REPO_CLAUDE. Aborting." >&2
  exit 1
fi

echo "Migrating ~/.claude from symlink to real directory..."

# Swap the symlink for a real directory. Only the link is removed; the
# repo directory and its contents are untouched.
rm "$LIVE"
mkdir "$LIVE"

# Move every file that git does not track out of the repo into ~/.claude.
# Tracked files (settings.json) stay in the repo and get symlinked below.
shopt -s dotglob nullglob
for path in "$REPO_CLAUDE"/*; do
  name="${path##*/}"
  rel="claude/$name"

  if git -C "$DOTFILES" ls-files --error-unmatch "$rel" >/dev/null 2>&1; then
    continue  # versioned — stays in the repo
  fi

  if [ -L "$path" ]; then
    # Symlinks created by a previous install.sh (CLAUDE.md, skills):
    # install.sh recreates them inside the new ~/.claude.
    rm "$path"
    continue
  fi

  case "$name" in
    .gitignore) rm -f "$path"; continue ;;  # no longer needed
  esac

  mv "$path" "$LIVE/"
  echo "  moved $name"
done

echo "Creating symlinks..."
"$DOTFILES/install.sh"

echo
echo "Done. Left in the repo:"
ls -A "$REPO_CLAUDE"
echo
echo "Verify with: git -C ~/dotfiles status"
