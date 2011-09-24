. ~/bin/bash_colors.sh

# Setup the path
export PATH="~/bin:${PATH}:/usr/local/bin"

# Use colors in the terminal
export TERM='xterm-color'
alias ls='ls -G'
alias ll='ls -lG'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

# Define common aliases
alias m=mate
alias gs='git status'
alias gd='git diff'
alias vi='mvim'
alias vim='mvim'

# Erase duplicates in history
export HISTCONTROL=erasedups
# Store 10k history entries
export HISTSIZE=10000
# Append to the history file when exiting instead of overwriting it
shopt -s histappend

# Custom prompt: host + working directory
PS1="\h:\W\$ "


. ~/bin/git-completion.bash
