. ~/bin/bash_colors.sh

# Setup the path
export PATH="~/bin:~/Android/sdk/tools:/usr/local/bin:/usr/local/share/npm/bin:/usr/local/heroku/bin:${PATH}"

# Use colors in the terminal
export TERM='xterm-color'
alias ls='ls -G'
alias ll='ls -lG'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"
export VISUAL='vim'

# Define common aliases
alias m=mate
alias gs='git status -sb'
alias gb='git branch'
alias gd='git diff'
alias gdk='git difftool -y -t Kaleidoscope'
alias gl='git log'
alias gp='git pull'
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

# Add locale information
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL=