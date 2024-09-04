alias gs='git status'
alias gb='git branch'
alias gc='git checkout'
alias gl='git log'
alias gd='git diff'
alias gpush='git push'
alias gpull='git pull'
alias gdmb='git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'

export PATH=/opt/homebrew/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH

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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
