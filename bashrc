# Don't print group names in long listings
if [[ $OSTYPE == linux* ]];
then
  alias ls='ls -G --color=auto'
  alias ll='ls -ltrG --color=auto'
fi
if [[ $OSTYPE == darwin* ]];
then
  alias ls='ls -G'
  alias ll='exa -Fla --sort newest --git'
  alias love='/Applications/love.app/Contents/MacOS/love'
fi

# Use VIM as the editor
export VISUAL='vim'

# Set a terminal color scheme
export TERM=xterm-256color

# Define common aliases
alias ga='git add'
alias gc='git commit -a'
alias gs='git status -sb'
alias gb='git branch -v'
alias gd='git diff'
alias gl='git log --oneline --graph'
alias gp='git push'
alias gpush='git push'
alias gpull='git pull'
alias gup='git log --branches --not --remotes' # Git UnPushed
alias bigfiles='du -hsx * | sort -rh | head -10'
alias uu='sudo apt-get update && sudo apt-get upgrade -y'
alias ..="cd .."
alias ...="cd ../.."
alias duh='du -h -d 1 | sort -h'

# Define pomo alias that plays noise for 25 minutes
alias pomo='play -n synth 25:0 brownnoise synth pinknoise mix synth sine amod 0.05 10'

# Make sure the open command is available on Linux.
if [[ $OSTYPE == linux* ]];
then
  alias open=xdg-open
fi

# Erase duplicates in history
export HISTCONTROL=erasedups
# Store 10k history entries
export HISTSIZE=10000
# Append to the history file when exiting instead of overwriting it
shopt -s histappend

# Custom prompt: user@host + working directory
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1='\[\033[01;28m\]\w\[\033[00;32m\]$(parse_git_branch) \[\033[0m\]$ '


# Git Autocomplete
. ~/bin/git-completion.bash

# Use Compiler Cache
export USE_CCACHE=1

# Set the number of open files to be 1024
ulimit -S -n 1024

# GO: set source path
export GOPATH="$HOME/go"

# Qt
export QTPATH="/usr/local/opt/qt"

# Android
export ANDROID_NDK_HOME="/usr/local/share/android-ndk"

# Add locale information
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL=

# Setup the path
export PATH="/usr/local/bin:${HOME}/bin:${GOPATH}/bin:${HOME}/.cargo/bin:${HOME}/google-cloud-sdk/bin:${QTPATH}/bin:$HOME/.yarn/bin:${PATH}"

if [ -f $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

# OS X: Change directory to topmost finder window.
function ff { osascript -e 'tell application "Finder"'\
    -e "if (${1-1} <= (count Finder windows)) then"\
    -e "get POSIX path of (target of window ${1-1} as alias)"\
    -e 'else' -e 'get POSIX path of (desktop as alias)'\
    -e 'end if' -e 'end tell'; };\

function cdff { cd "`ff $@`"; };
