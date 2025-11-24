#!/bin/bash
# Configure Python settings for Cursor/VS Code on Vertex AI Workbench
# Run this on the remote instance

echo "🐍 Configuring Python settings for Cursor/VS Code..."

# Create .vscode directory in home
mkdir -p /home/jupyter/.vscode

# Create settings.json
cat > /home/jupyter/.vscode/settings.json << 'EOF'
{
    "python.defaultInterpreterPath": "/opt/conda/bin/python",
    "python.pythonPath": "/opt/conda/bin/python",
    "python.terminal.activateEnvironment": true,
    "python.terminal.activateEnvInCurrentTerminal": true
}
EOF

echo "✅ Python settings configured!"
echo "Python interpreter: /opt/conda/bin/python"
echo ""
echo "These settings will persist across VM restarts."
echo "Reconnect to the instance in Cursor to apply the changes."


# Create settings.json
mkdir .vscode
cat > .vscode/settings.json << 'EOF'
{
    "python.defaultInterpreterPath": "/opt/conda/bin/python",
    "python.pythonPath": "/opt/conda/bin/python",
}
EOF