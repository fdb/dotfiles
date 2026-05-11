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
for item in CLAUDE.md skills commands settings.json keybindings.json; do
  src=~/dotfiles/claude/$item
  dest=~/.claude/$item
  link_dotfile "$src" "$dest"
done

# Symlink versioned agents config items into ~/.agents/ (don't replace the whole directory).
mkdir -p ~/.agents
for item in AGENTS.md; do
  src=~/dotfiles/agents/$item
  dest=~/.agents/$item
  link_dotfile "$src" "$dest"
done
mkdir -p ~/.agents/skills
if [ -d ~/dotfiles/agents/skills ]; then
  for dest in ~/.agents/skills/*; do
    [ ! -L "$dest" ] && continue
    target=$(readlink "$dest")
    case "$target" in
      "$HOME"/dotfiles/agents/skills/*)
        [ -e "$target" ] || rm -f "$dest"
        ;;
    esac
  done

  for src in ~/dotfiles/agents/skills/*; do
    [ ! -e "$src" ] && continue
    item=$(basename "$src")
    dest=~/.agents/skills/$item
    link_dotfile "$src" "$dest"
  done
fi

if [[ $OSTYPE == darwin* ]];
then
  ln -sfn ~/dotfiles/ssh-config ~/.ssh/config
fi

# Install Claude Code plugins if claude is available.
if command -v claude &> /dev/null; then
  claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null
  claude plugin install frontend-design@claude-plugins-official playwright@claude-plugins-official ralph-loop@claude-plugins-official code-simplifier@claude-plugins-official swift-lsp@claude-plugins-official rust-analyzer-lsp@claude-plugins-official code-review@claude-plugins-official 2>/dev/null
fi
