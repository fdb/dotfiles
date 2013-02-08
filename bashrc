. ~/bin/bash_colors.sh

# Setup the path
export PATH="~/bin:/usr/local/bin:/usr/local/heroku/bin:${PATH}"

# Use colors in the terminal
export TERM='xterm-color'
alias ls='ls -G'
alias ll='ls -lG'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"
export VISUAL='vim'

# Define common aliases
alias m=mate
alias git=hub
alias gs='git status -sb'
alias gb='git branch'
alias gd='git diff'
alias gdk='git difftool -y -t Kaleidoscope'
alias gl='git log'
alias gp='git pull'

# Erase duplicates in history
export HISTCONTROL=erasedups
# Store 10k history entries
export HISTSIZE=10000
# Append to the history file when exiting instead of overwriting it
shopt -s histappend

# Custom prompt: host + working directory
PS1="\h:\W\$ "

# Git Autocomplete
. ~/bin/git-completion.bash

# Use Compiler Cache
export USE_CCACHE=1

# Set the number of open files to be 1024
ulimit -S -n 1024

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
