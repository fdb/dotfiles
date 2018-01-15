# Don't print group names in long listings
if [[ $OSTYPE == linux* ]];
then
  alias ls='ls -G --color=auto'
  alias ll='ls -lG --color=auto'
fi
if [[ $OSTYPE == darwin* ]];
then
  alias ls='ls -G'
  alias ll='exa -Fla --git'
fi

# Use VIM as the editor
export VISUAL='vim'

# Define common aliases
alias ga='git add'
alias gc='git commit -a'
alias gs='git status -sb'
alias gb='git branch'
alias gd='git diff'
alias gl='git log --oneline --graph'
alias gp='git push'
alias gpush='git push'
alias gpull='git pull'
alias gup='git log --branches --not --remotes' # Git UnPushed
alias bigfiles='du -hsx * | sort -rh | head -10'
alias uu='sudo apt-get update && sudo apt-get upgrade -y'

# Make sure the open command is available on Linux.
if [[ $OSTYPE == linux* ]];
then
  alias open=gnome-open
fi

# Erase duplicates in history
export HISTCONTROL=erasedups
# Store 10k history entries
export HISTSIZE=10000
# Append to the history file when exiting instead of overwriting it
shopt -s histappend

# Custom prompt: user@host + working directory
export PS1="\u@\h:\W$ "

# Git Autocomplete
. ~/bin/git-completion.bash

# Use Compiler Cache
export USE_CCACHE=1

# Set the number of open files to be 1024
ulimit -S -n 1024

# GO: set source path
export GOPATH="$HOME/go"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# Qt
export QTPATH="/usr/local/opt/qt"

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
export PATH="/usr/local/bin:${HOME}/bin:${GOPATH}/bin:${HOME}/.cargo/bin:${QTPATH}/bin:${PATH}"

source $HOME/.cargo/env

# OS X: Change directory to topmost finder window.
function ff { osascript -e 'tell application "Finder"'\
    -e "if (${1-1} <= (count Finder windows)) then"\
    -e "get POSIX path of (target of window ${1-1} as alias)"\
    -e 'else' -e 'get POSIX path of (desktop as alias)'\
    -e 'end if' -e 'end tell'; };\

function cdff { cd "`ff $@`"; };

