#!/bin/bash
# Symlink all dot files to their correct positions.

# Delete directories that are in the way.
rm -rf ~/bin
rm -rf ~/.vim

# Create new directories.
mkdir -p ~/.ssh

# Symlink all config files.
ln -sfn ~/dotfiles/bashrc ~/.bashrc
ln -sfn ~/dotfiles/bash_profile ~/.bash_profile
ln -sfn ~/dotfiles/gitconfig ~/.gitconfig
ln -sfn ~/dotfiles/global-gitignore ~/.global-gitignore
ln -sfn ~/dotfiles/screenrc ~/.screenrc
ln -sfn ~/dotfiles/sqliterc ~/.sqliterc
ln -sfn ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sfn ~/dotfiles/vim ~/.vim
ln -sfn ~/dotfiles/vimrc ~/.vimrc
ln -sfn ~/dotfiles/emacs ~/.emacs
ln -sfn ~/dotfiles/bin ~/bin
ln -sfn ~/dotfiles/radare2rc ~/.radare2rc
ln -sfn ~/dotfiles/zshrc ~/.zshrc
ln -sfn ~/dotfiles/claude ~/.claude

if [[ $OSTYPE == darwin* ]];
then
  ln -sfn ~/dotfiles/ssh-config ~/.ssh/config
fi

# Install Claude Code plugins if claude is available.
if command -v claude &> /dev/null; then
  claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null
  claude plugin install frontend-design@claude-plugins-official playwright@claude-plugins-official ralph-loop@claude-plugins-official code-simplifier@claude-plugins-official swift-lsp@claude-plugins-official rust-analyzer-lsp@claude-plugins-official code-review@claude-plugins-official 2>/dev/null
fi
