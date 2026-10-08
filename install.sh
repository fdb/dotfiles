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

# Symlink pi agent config files.
mkdir -p ~/.pi/agent
link_dotfile ~/dotfiles/pi/models.json ~/.pi/agent/models.json

# Symlink Claude config files. ~/.claude itself is a real directory holding
# local state (credentials, sessions); only these files are versioned.
# If ~/.claude is still a symlink into this repo, run ./migrate-claude-dir.sh.
mkdir -p ~/.claude
link_dotfile ~/dotfiles/claude/settings.json ~/.claude/settings.json
link_dotfile ~/dotfiles/agents/AGENTS.md ~/.claude/CLAUDE.md
# ~/.claude/skills is a real directory, because Claude Code keeps its own
# state there (synced/). If it is a symlink into this repo, replace it and
# move that state out of the repo. Then link each skill individually and
# prune links whose repo side is gone.
[ -L ~/.claude/skills ] && rm ~/.claude/skills
mkdir -p ~/.claude/skills
if [ -d ~/dotfiles/agents/skills/synced ] && [ ! -e ~/.claude/skills/synced ]; then
  mv ~/dotfiles/agents/skills/synced ~/.claude/skills/synced
fi
for skill_dir in ~/dotfiles/agents/skills/*/; do
  link_dotfile "${skill_dir%/}" ~/.claude/skills/"$(basename "$skill_dir")"
done
for link in ~/.claude/skills/*; do
  [ -L "$link" ] || continue
  [ -e "$link" ] && continue
  case "$(readlink "$link")" in
    "$HOME"/dotfiles/*) rm "$link" ;;
  esac
done

# nvm + Node LTS. PROFILE=/dev/null keeps the installer from appending to the
# symlinked rc files; shell_common loads nvm at shell start.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | PROFILE=/dev/null bash
fi
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
  [ "$(nvm version default)" = "N/A" ] && nvm install --lts
fi

# Install Claude Code plugins if claude is available.
if command -v claude &> /dev/null; then
  claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null
  claude plugin install frontend-design@claude-plugins-official playwright@claude-plugins-official ralph-loop@claude-plugins-official code-simplifier@claude-plugins-official swift-lsp@claude-plugins-official rust-analyzer-lsp@claude-plugins-official code-review@claude-plugins-official 2>/dev/null
fi
