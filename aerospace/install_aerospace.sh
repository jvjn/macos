#brew install --cask nikitabobko/tap/aerospace

# Backup and symlink aerospace config
if [ -d ~/.oh-my-zsh/custom ] && [ ! -L ~/.oh-my-zsh/custom ]; then
  mv ~/.aerospace.toml ~/.aerospace.toml.backup
fi
ln -sf $(pwd)/dotfiles/aerospace.toml ~/.aerospace.toml

echo "✅ Installation complete!"

