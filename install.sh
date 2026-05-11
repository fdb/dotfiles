#!/bin/bash
# Symlink all dot files to their correct positions.

# Delete directories that are in the way.
rm -rf ~/bin
rm -rf ~/.vim

# Create new directories.
mkdir -p ~/.ssh

link_dotfile() {
  src=$1
  dest=$2

  [ ! -e "$src" ] && return
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "WARNING: $dest already exists and is not a symlink — skipping (won't overwrite)"
  else
    rm -f "$dest"
    ln -s "$src" "$dest"
  fi
}

# Symlink all config files.
ln -sfn ~/dotfiles/bashrc ~/.bashrc
ln -sfn ~/dotfiles/bash_profile ~/.bash_profile
ln -sfn ~/dotfiles/gitconfig ~/.gitconfig
ln -sfn ~/dotfiles/global-gitignore ~/.global-gitignore
ln -sfn ~/dotfiles/screenrc ~/.screenrc
ln -sfn ~/dotfiles/sqliterc ~/.sqliterc
ln -sfn ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sfn ~/dotfiles/vim ~/.vim
ln -sfn ~/dotfiles/vimrc ~/.vimrc
ln -sfn ~/dotfiles/emacs ~/.emacs
ln -sfn ~/dotfiles/bin ~/bin
ln -sfn ~/dotfiles/radare2rc ~/.radare2rc
ln -sfn ~/dotfiles/zshrc ~/.zshrc
# Symlink versioned Claude config items into ~/.claude/ (don't replace the whole directory).
mkdir -p ~/.claude
for item in CLAUDE.md commands settings.json keybindings.json; do
  src=~/dotfiles/claude/$item
  dest=~/.claude/$item
  link_dotfile "$src" "$dest"
done

# Symlink skills from agents/ into ~/.agents/skills/ and ~/.claude/skills/.
# agents/skills/ is the single source of truth for all skills.
skill_src=~/dotfiles/agents/skills

for dest_dir in ~/.agents/skills ~/.claude/skills; do
  mkdir -p "$dest_dir"
  # Prune stale symlinks pointing at our skills source
  for dest in "$dest_dir"/*; do
    [ ! -L "$dest" ] && continue
    target=$(readlink "$dest")
    case "$target" in
      "$HOME"/dotfiles/agents/skills/*)
        [ -e "$target" ] || rm -f "$dest"
        ;;
    esac
  done

  for src in $skill_src/*; do
    [ ! -e "$src" ] && continue
    item=$(basename "$src")
    dest="$dest_dir/$item"
    link_dotfile "$src" "$dest"
  done
done

# Symlink agents AGENTS.md into ~/.agents/.
mkdir -p ~/.agents
link_dotfile ~/dotfiles/agents/AGENTS.md ~/.agents/AGENTS.md

if [[ $OSTYPE == darwin* ]];
then
  ln -sfn ~/dotfiles/ssh-config ~/.ssh/config
fi

# Install Claude Code plugins if claude is available.
if command -v claude &> /dev/null; then
  claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null
  claude plugin install frontend-design@claude-plugins-official playwright@claude-plugins-official ralph-loop@claude-plugins-official code-simplifier@claude-plugins-official swift-lsp@claude-plugins-official rust-analyzer-lsp@claude-plugins-official code-review@claude-plugins-official 2>/dev/null
fi
