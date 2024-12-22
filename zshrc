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

export PATH=/opt/homebrew/bin:~/.local/bin::~/go/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH

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

# Fly.io
export FLYCTL_INSTALL="/Users/fdb/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
