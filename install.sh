#!/bin/bash
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
ln -sf ~/dotfiles/sqliterc ~/.sqliterc
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/vim ~/.vim
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/emacs ~/.emacs
ln -sf ~/dotfiles/bin ~/bin
ln -sf ~/dotfiles/radare2rc ~/.radare2rc
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/claude ~/.claude

if [[ $OSTYPE == darwin* ]];
then
  ln -sf ~/dotfiles/ssh-config ~/.ssh/config
fi

# Install Claude Code plugins if claude is available.
if command -v claude &> /dev/null; then
  claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null
  claude plugin install frontend-design@claude-plugins-official playwright@claude-plugins-official ralph-loop@claude-plugins-official code-simplifier@claude-plugins-official swift-lsp@claude-plugins-official rust-analyzer-lsp@claude-plugins-official code-review@claude-plugins-official 2>/dev/null
fi
