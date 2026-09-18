# AGENTS.md

This is a personal dotfiles repository for macOS and Linux. Configuration files are stored here and symlinked to their expected locations in the home directory. Inside of this directory, use `filename` instead of `.filename`, e.g. `.vimrc` should be `vimrc` in this directory.

## Installation

```bash
./install.sh
```

This script symlinks all dotfiles to `~/` (e.g., `bashrc` → `~/.bashrc`). It assumes the repo is cloned to `~/dotfiles`.

On macOS, `./setup-macos.sh` writes system defaults (screenshots save straight to the Desktop, no floating thumbnail).

## Repository Structure

- **Shell configs**: `shell_common` (shared aliases/functions), `zshrc` (macOS), `bashrc` (Linux), `bash_profile`
- **Editor configs**: `vimrc`, `emacs`, `vim/` (includes Pathogen + bundled plugins: ctrlp, editorconfig, emmet)
- **Git**: `gitconfig`, `global-gitignore`
- **Utilities**: `bin/` - helper scripts (gif2mp4, gifit, git-completion.bash, mvim). `install.sh` symlinks it to `~/bin`; `zshrc` and `bashrc` both put `~/bin` on `PATH`.
- **Other**: `tmux.conf`, `screenrc`, `ssh-config` (macOS only), `radare2rc`, `sqliterc`
- **pi**: `pi/models.json` - provider config for the pi agent (symlinked to `~/.pi/agent/models.json`)
- **Agents**: `agents/`, `claude/` - coding agents skills etc

