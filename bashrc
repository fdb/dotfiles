. ~/bin/bash_colors.sh

# Setup the path
export PATH="~/bin:/usr/local/bin:${PATH}"

# Use colors in the terminal
export TERM='xterm-color'
alias ls='ls -G'
alias ll='ls -lG'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

# Define common aliases
alias m=mate
alias gs='git status -sb'
alias gb='git branch'
alias gd='git diff'
alias gdk='git difftool -y -t Kaleidoscope'
alias gl='git log'

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

# Todo.sh
alias t=todo.sh
source ~/.todo/completion
complete -F _todo t
