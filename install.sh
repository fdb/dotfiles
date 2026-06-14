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
    ln -sfn "$src" "$dest"
  fi
}

# Symlink all config files.
link_dotfile ~/dotfiles/bashrc ~/.bashrc
link_dotfile ~/dotfiles/bash_profile ~/.bash_profile
link_dotfile ~/dotfiles/gitconfig ~/.gitconfig
link_dotfile ~/dotfiles/global-gitignore ~/.global-gitignore
link_dotfile ~/dotfiles/screenrc ~/.screenrc
link_dotfile ~/dotfiles/sqliterc ~/.sqliterc
link_dotfile ~/dotfiles/tmux.conf ~/.tmux.conf
link_dotfile ~/dotfiles/vim ~/.vim
link_dotfile ~/dotfiles/vimrc ~/.vimrc
link_dotfile ~/dotfiles/emacs ~/.emacs
link_dotfile ~/dotfiles/bin ~/bin
link_dotfile ~/dotfiles/radare2rc ~/.radare2rc
link_dotfile ~/dotfiles/zshrc ~/.zshrc

# Symlink agents config files.
mkdir -p ~/.agents
link_dotfile ~/dotfiles/agents/AGENTS.md ~/.agents/AGENTS.md
link_dotfile ~/dotfiles/agents/skills ~/.agents/skills

# Symlink Claude config files.
mkdir -p ~/.claude
link_dotfile ~/dotfiles/claude/settings.json ~/.claude/settings.json
link_dotfile ~/dotfiles/agents/AGENTS.md ~/.claude/CLAUDE.md
link_dotfile ~/dotfiles/agents/skills ~/.claude/skills

# Install Claude Code plugins if claude is available.
if command -v claude &> /dev/null; then
  claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null
  claude plugin install frontend-design@claude-plugins-official playwright@claude-plugins-official ralph-loop@claude-plugins-official code-simplifier@claude-plugins-official swift-lsp@claude-plugins-official rust-analyzer-lsp@claude-plugins-official code-review@claude-plugins-official 2>/dev/null
fi
