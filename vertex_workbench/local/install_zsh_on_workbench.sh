#!/bin/bash
# Execute this script via cursor's terminal when you are remoted into a vertex workbench instance

set -e

echo "🔧 Installing zsh and oh-my-zsh on Vertex AI Workbench..."

# Update package lists
echo "📦 Updating package lists..."
sudo apt-get update

# Install zsh
echo "📦 Installing zsh..."
sudo apt-get install -y zsh

# Install oh-my-zsh
echo "🎨 Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install popular plugins
echo "🔌 Installing zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

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

# Configure bash to auto-start zsh
echo "🔧 Configuring auto-start..."
if ! grep -q "exec zsh" ~/.bashrc; then
  echo '
# Auto-start zsh
if [ -t 1 ] && [ -x "$(command -v zsh)" ]; then
  export SHELL=$(which zsh)
  exec zsh
fi
' >> ~/.bashrc
fi

# Configure VS Code/Cursor Python settings
#echo "🐍 Configuring Python settings for Cursor/VS Code..."
#mkdir -p /home/jupyter/.vscode
#cat > /home/jupyter/.vscode/settings.json << 'EOF'
#{
#    "python.defaultInterpreterPath": "/opt/conda/bin/python",
#    "python.pythonPath": "/opt/conda/bin/python",
#    "python.terminal.activateEnvironment": true,
#    "python.terminal.activateEnvInCurrentTerminal": true
#}
#EOF

echo "✅ Installation complete!"
echo "Theme: fox"
echo "Plugins: git, docker, kubectl, python, pip, zsh-autosuggestions, zsh-syntax-highlighting"
echo "Python interpreter: /opt/conda/bin/python"
echo ""
echo "⚠️  Please restart your terminal or run: source ~/.bashrc"
