# Source common shell configuration
source ~/dotfiles/shell_common

# Enable zsh completion system (for git, etc.)
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit

# zsh-specific settings
[ -f /opt/homebrew/bin/fzf ] && source <(fzf --zsh)

# macOS-specific aliases
alias ll='exa -Fla --sort newest --git'
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Video compression helper
compress_video() {
    local input_file="$1"
    local output_file="${input_file:r}.mp4"
    ffmpeg -y -i "$input_file" -vf "scale=-2:1080" -r 15 -crf 28 -pix_fmt yuv420p -movflags +faststart "$output_file"
}

# Local LLM
alias llama='llama-server -hf ggml-org/gpt-oss-20b-GGUF --ctx-size 0 --jinja -ub 2048 -b 2048 -ngl 99 -fa'

# PATH additions
export PATH=~/.local/bin:/opt/homebrew/bin:/go/bin:$PATH

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/fdb/.lmstudio/bin"

# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/fdb/Library/Application Support/Herd/config/php/84/"

# Herd injected NVM configuration
export NVM_DIR="/Users/fdb/Library/Application Support/Herd/config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

# Herd injected PHP binary.
export PATH="/Users/fdb/Library/Application Support/Herd/bin/":$PATH

# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/fdb/Library/Application Support/Herd/config/php/83/"

# Added by Antigravity
export PATH="/Users/fdb/.antigravity/antigravity/bin:$PATH"

# GHCup (Haskell)
if [ -f "${HOME}/.ghcup/env" ]; then
    source "${HOME}/.ghcup/env"
fi

# Amp CLI
export PATH="/Users/fdb/.amp/bin:$PATH"

# GNU Radio Companion fix
export GSETTINGS_SCHEMA_DIR=/opt/homebrew/share/glib-2.0/schemas
