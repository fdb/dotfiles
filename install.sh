#!/bin/sh
# Symlink all dot files to their correct positions.

# Delete directories that are in the way.
rm -rf ~/bin
rm -rf ~/.vim
rm -rf ~/.todo

ln -sf ~/dotfiles/bashrc ~/.bashrc
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/screenrc ~/.screenrc
ln -sf ~/dotfiles/vim ~/.vim
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/bin ~/bin
ln -sf ~/dotfiles/todo ~/.todo
