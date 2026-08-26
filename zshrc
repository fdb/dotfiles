# Source common shell configuration
source ~/dotfiles/shell_common

# Enable zsh completion system (for git, etc.)
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit

# zsh-specific settings
[ -f /opt/homebrew/bin/fzf ] && source <(fzf --zsh)

# Git prompt: branch + clean/dirty indicator (⋅).
# White ⋅ = clean, orange ⋅ = dirty. Uses primitives from shell_common.
git_prompt_info() {
  local branch
  branch=$(git_current_branch) || return
  if git_is_dirty; then
    echo " %F{208}${branch} ⋅%f"
  else
    echo " %F{white}${branch} ⋅%f"
  fi
}
setopt PROMPT_SUBST
PROMPT='%~$(git_prompt_info) $ '

# macOS-specific aliases
alias ll='exa -Fla --sort newest --git'
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Local LLM
alias llama='llama-server -hf ggml-org/gpt-oss-20b-GGUF --ctx-size 0 --jinja -ub 2048 -b 2048 -ngl 99 -fa'

# PATH additions
export PATH=~/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/go/bin:$PATH

# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/fdb/Library/Application Support/Herd/config/php/84/"

# Herd injected PHP binary.
export PATH="/Users/fdb/Library/Application Support/Herd/bin/":$PATH

# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/fdb/Library/Application Support/Herd/config/php/83/"

# GNU Radio Companion fix
export GSETTINGS_SCHEMA_DIR=/opt/homebrew/share/glib-2.0/schemas
