alias gs='git status'
alias gb='git branch'
alias gc='git checkout'
alias gl='git log'
alias gd='git diff'
alias gpush='git push'
alias gpull='git pull'
alias s='/Applications/Sublime\ Text.app/Contents/MacOS/Sublime\ Text'

export PATH=/usr/local/bin:/usr/local/opt/qt/bin:$PATH
# Serve / browsersync
export LOCAL_IP=`ipconfig getifaddr en0`
alias serve="browser-sync start -s -f . --no-notify --host $LOCAL_IP --port 9000"
