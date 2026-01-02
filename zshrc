alias gs='git status'
alias gb='git branch'
alias gc='git checkout'
alias gl='git log'
alias gd='git diff'
alias gpush='git push'
alias gpull='git pull'
alias gdmb='git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'
function cheat() { curl cheat.sh/$1 }
function up() { cd $(eval printf '../'%.0s {1..$1}); }
alias ..="cd .."
alias ...="cd ../.."
alias duh='du -h -d 1 | sort -h'

# Set type of terminal
export TERM=xterm-256color

export PATH=/opt/homebrew/bin:~/.local/bin:~/go/bin:$PATH

[ -f /opt/homebrew/bin/fzf ] &&  source <(fzf --zsh)

compress_video() {
    local input_file="$1"
    local output_file="${input_file:r}.mp4"
    ffmpeg -y -i "$input_file" -vf "scale=-2:1080" -r 15 -crf 28 -pix_fmt yuv420p -movflags +faststart "$output_file"
}

ff() {
    osascript -e 'tell application "Finder"' \
    -e "if (${1-1} <= (count Finder windows)) then" \
    -e "get POSIX path of (target of window ${1-1} as alias)" \
    -e 'else' -e 'get POSIX path of (desktop as alias)' \
    -e 'end if' -e 'end tell'
}

cdff() {
    cd "$(ff "$@")"
}

# llvm
export LLVM_PATH="$(brew --prefix llvm)"
export PATH="$LLVM_PATH/bin:$PATH"
export LDFLAGS="-L$LLVM_PATH/lib"
export CPPFLAGS="-I$LLVM_PATH/include"

# Tailscale
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Codex
alias ccc='codex --yolo'

alias llama='llama-server -hf ggml-org/gpt-oss-20b-GGUF --ctx-size 0 --jinja -ub 2048 -b 2048 -ngl 99 -fa'


# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/fdb/Library/Application Support/Herd/config/php/84/"


# Herd injected NVM configuration
export NVM_DIR="/Users/fdb/Library/Application Support/Herd/config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

# Herd injected PHP binary.
export PATH="/Users/fdb/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/fdb/Library/Application Support/Herd/config/php/83/"
