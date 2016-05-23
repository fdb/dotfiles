. ~/bin/bash_colors.sh

# Use colors in the terminal
export TERM='xterm-color'
alias ls='ls -G'
alias ll='ls -lG'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"
export VISUAL='vim'

# Define common aliases
alias gs='git status -sb'
alias gb='git branch'
alias gd='git diff'
alias gdk='git difftool -y -t Kaleidoscope'
alias gl='git log --oneline --graph'
alias gp='git pull'
alias gup='git log --branches --not --remotes' # Git UnPushed
alias bigfiles='du -hsx * | sort -rh | head -10'
alias uu='sudo apt-get update && sudo apt-get upgrade -y'

# Make sure the open command is available on Linux.
if [[ $OSTYPE == linux* ]];
then
  alias open=gnome-open
fi

if [[ $OSTYPE == darwin* ]];
then
    alias emacs=/Applications/Emacs.app/Contents/MacOS/Emacs
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

# Rust: set source path
export RUST_SRC_PATH=~/Source/rust/src

# GO: set source path
export GOPATH=~/go

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
export PATH="~/bin:~/Android/sdk/tools:/usr/local/bin:/usr/local/share/npm/bin:/usr/local/heroku/bin:${GOPATH}/bin:/Users/fdb/.cargo/bin:${PATH}"

# OS X: Change directory to topmost finder window.
function ff { osascript -e 'tell application "Finder"'\
    -e "if (${1-1} <= (count Finder windows)) then"\
    -e "get POSIX path of (target of window ${1-1} as alias)"\
    -e 'else' -e 'get POSIX path of (desktop as alias)'\
    -e 'end if' -e 'end tell'; };\

function cdff { cd "`ff $@`"; };
