#!/bin/sh
# Symlink all dot files to their correct positions.

# Delete directories that are in the way.
rm -rf ~/bin
rm -rf ~/.vim

# Create new directories.
mkdir -p ~/.ssh

# Symlink all config files.
ln -sf ~/dotfiles/bashrc ~/.bashrc
ln -sf ~/dotfiles/bash_profile ~/.bash_profile
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/global-gitignore ~/.global-gitignore
ln -sf ~/dotfiles/screenrc ~/.screenrc
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/vim ~/.vim
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/emacs ~/.emacs
ln -sf ~/dotfiles/bin ~/bin
ln -sf ~/dotfiles/npmrc ~/.npmrc
ln -sf ~/dotfiles/ssh-config ~/.ssh/config

