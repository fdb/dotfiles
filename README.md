# dotfiles

Frederik's personal dotfiles for macOS and Linux.

## Install

```bash
git clone https://github.com/fdb/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` symlinks each top-level config into `~/` (e.g. `bashrc` → `~/.bashrc`). It is idempotent: re-running it replaces stale symlinks but leaves real files alone with a warning.

## What's in here

Shell (bash + zsh), vim, git, tmux, emacs configs, plus a `bin/` of helper scripts (`compress_video`, `convert_gif`, `kill_port`, `mvim`, …) and a `claude/` directory of Claude Code config that gets installed per-item into `~/.claude/`.

See [AGENTS.md](AGENTS.md) for the full layout and conventions.
