# AGENTS.md

This is a personal dotfiles repository for macOS and Linux. Configuration files are stored here and symlinked to their expected locations in the home directory. Inside of this directory, use `filename` instead of `.filename`, e.g. `.vimrc` should be `vimrc` in this directory.

## Installation

```bash
./install.sh
```

This script symlinks all dotfiles to `~/` (e.g., `bashrc` → `~/.bashrc`). It assumes the repo is cloned to `~/dotfiles`.

## Repository Structure

- **Shell configs**: `shell_common` (shared aliases/functions), `zshrc` (macOS), `bashrc` (Linux), `bash_profile`
- **Editor configs**: `vimrc`, `emacs`, `vim/` (includes Pathogen + bundled plugins: ctrlp, editorconfig, emmet)
- **Git**: `gitconfig`, `global-gitignore`
- **Utilities**: `bin/` - helper scripts (gif2mp4, gifit, git-completion.bash, mvim)
- **Other**: `tmux.conf`, `screenrc`, `ssh-config` (macOS only), `radare2rc`, `sqliterc`
- **Agents**: `agents/`, `claude/` - coding agents skills etc

