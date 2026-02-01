# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository for macOS and Linux. Configuration files are stored here and symlinked to their expected locations in the home directory.

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

## Key Customizations

**Git aliases** (defined in `gitconfig`):
- `st`, `ci`, `co`, `di`, `dc` - common shortcuts
- `incoming`/`outgoing` - show unpushed/unpulled commits
- `latest` - branches sorted by commit date

**Shell aliases** (defined in `shell_common`, available in both shells):
- `gs`, `ga`, `gaa`, `gb`, `gco`, `gc`, `gcm`, `gca`, `gd`, `gdc`, `gf`, `gpush`, `gpull`, `gss`, `gsp` - git shortcuts
- `..`, `...` - directory navigation
- `duh` - human-readable disk usage sorted by size
- `ff`/`cdff` - navigate to Finder window path (macOS)
- `cheat <cmd>` - lookup command cheat sheet

**Vim**:
- Leader key: `,`
- `jj` mapped to Escape
- `<leader><leader>` switches between last two files
- Auto-trims trailing whitespace on save
- 2-space indentation (tabs for Go files)
