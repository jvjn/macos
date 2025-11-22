#!/bin/bash

# Backup and symlink Oh My Zsh custom folder
if [ -d ~/.oh-my-zsh/custom ] && [ ! -L ~/.oh-my-zsh/custom ]; then
  mv ~/.oh-my-zsh/custom ~/.oh-my-zsh/custom.backup
fi
ln -sf $(pwd)/dotfiles/oh-my-zsh-custom ~/.oh-my-zsh/custom

# Backup and symlink zshrc
if [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
  mv ~/.zshrc ~/.zshrc.backup
fi
ln -sf $(pwd)/dotfiles/zshrc ~/.zshrc

echo "✅ Installation complete!"
echo "Run 'source ~/.zshrc' or open a new terminal to apply changes."
mv ~/.zshrc ~/.zshrc.backup
ln -s $(pwd)/dotfiles/zshrc ~/.zshrc
