# Source common shell configuration
source ~/dotfiles/shell_common

# Linux-specific settings
if [[ $OSTYPE == linux* ]]; then
    alias ls='ls -G --color=auto'
    alias ll='ls -ltrG --color=auto'
    alias open=xdg-open
    alias uu='sudo apt-get update && sudo apt-get upgrade -y'
fi

# macOS-specific settings
if [[ $OSTYPE == darwin* ]]; then
    alias ls='ls -G'
    alias ll='exa -Fla --sort newest --git'
    alias love='/Applications/love.app/Contents/MacOS/love'
fi

# Use VIM as the editor
export VISUAL='vim'

# Erase duplicates in history
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend

# Custom prompt with git branch
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

# Locale
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL=

# PATH
export PATH="/usr/local/bin:${HOME}/bin:${GOPATH}/bin:${HOME}/.cargo/bin:${HOME}/google-cloud-sdk/bin:${QTPATH}/bin:$HOME/.yarn/bin:${PATH}"

# Cargo/Rust
if [ -f $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

# GHCup (Haskell)
if [ -f "${HOME}/.ghcup/env" ]; then
    source "${HOME}/.ghcup/env"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/fdb/.lmstudio/bin"
