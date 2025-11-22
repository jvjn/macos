#!/bin/bash

set -e

echo "🔧 Installing zsh and oh-my-zsh for jupyter user..."

# Install oh-my-zsh (zsh should already be installed from SSH script)
echo "🎨 Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install popular plugins
echo "🔌 Installing zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true

# Change theme to fox
echo "🎨 Setting theme to 'fox'..."
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="fox"/' ~/.zshrc

# Update plugins
echo "🔌 Configuring plugins..."
sed -i 's/plugins=(git)/plugins=(git docker kubectl python pip zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# Set default directory to /home/jupyter
echo "📁 Setting default directory to /home/jupyter..."
echo '
# Set default directory
cd /home/jupyter
' >> ~/.zshrc

# Configure multiple startup files to ensure zsh starts
echo "🔧 Configuring auto-start in .bashrc..."
if ! grep -q "exec zsh" ~/.bashrc; then
  echo '
# Auto-start zsh
if [ -t 1 ] && [ -x "$(command -v zsh)" ]; then
  export SHELL=$(which zsh)
  exec zsh
fi
' >> ~/.bashrc
fi

echo "🔧 Configuring auto-start in .bash_profile..."
if ! grep -q "exec zsh" ~/.bash_profile 2>/dev/null; then
  echo '
# Auto-start zsh
if [ -t 1 ] && [ -x "$(command -v zsh)" ]; then
  export SHELL=$(which zsh)
  exec zsh
fi
' >> ~/.bash_profile
fi

echo "🔧 Configuring auto-start in .profile..."
if ! grep -q "exec zsh" ~/.profile 2>/dev/null; then
  echo '
# Auto-start zsh
if [ -t 1 ] && [ -x "$(command -v zsh)" ]; then
  export SHELL=$(which zsh)
  exec zsh
fi
' >> ~/.profile
fi

echo ""
echo "✅ Installation complete for jupyter user!"
echo ""
echo "⚠️  Close this terminal and open a new one in JupyterLab UI"
echo ""
echo "🔍 If zsh doesn't start automatically, run this to debug:"
echo "   echo \$SHELL"
echo "   cat ~/.bashrc | grep zsh"