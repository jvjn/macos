#!/bin/bash

# ============================================================================
# Vertex AI Workbench Startup Script
# ============================================================================
#
# PURPOSE:
#   This script configures a Vertex AI Workbench instance with zsh, oh-my-zsh,
#   and custom settings for all users. It runs automatically at instance startup.
#
# SETUP INSTRUCTIONS:
#   1. Upload this script to a Google Cloud Storage (GCS) bucket:
#      gsutil cp on_startup.sh gs://your-bucket-name/startup-scripts/
#
#   2. When creating a Workbench instance, specify this script in the startup
#      script configuration:
#      - Via Console: Under "Advanced Options" → "Startup script" → 
#        Enter the GCS path: your-bucket-name/startup-scripts/on_startup.sh
#      - Via gcloud CLI: Use the --metadata flag:
#        gcloud workbench instances create INSTANCE_NAME \
#          --location=LOCATION \
#          --metadata="startup-script-url=gs://your-bucket-name/startup-scripts/on_startup.sh"
#
#   3. The script will automatically download and execute on every instance start.
#
# IMPORTANT CAVEAT - First Remote Connection:
#   If you plan to connect remotely via CLI or Cursor (using SSH over IAP),
#   you MUST restart the instance after your first connection.
#
#   Why? Vertex Workbench instances accessed via IAP create the user's home 
#   directory only AFTER the first remote connection. This script runs at 
#   startup before the user directory exists, so zsh setup for remote users 
#   won't complete until after the first connection + restart cycle.
#
#   Workflow:
#     1. Create instance with this startup script
#     2. Connect via SSH/Cursor for the first time (user directory gets created)
#     3. Restart the instance: wb-restart INSTANCE_NAME
#     4. On next connection, zsh will be fully configured
#
# WHAT THIS SCRIPT DOES:
#   - Installs zsh, git, and curl
#   - Configures oh-my-zsh for all users (jupyter + any IAP users)
#   - Installs zsh plugins: autosuggestions, syntax-highlighting
#   - Initializes conda and activates base environment automatically
#   - Sets JupyterLab terminal to use zsh
#   - Sets JupyterLab theme to dark mode
#   - Configures proper permissions for multi-user access
#
# ============================================================================

echo "🔧 Installing zsh and oh-my-zsh..."

# Install zsh
apt-get update
apt-get install -y zsh git curl

# Create a shared group for jupyter access
groupadd -f jupyter-users
usermod -aG jupyter-users jupyter

# Set /home/jupyter to be group-writable
chown -R jupyter:jupyter-users /home/jupyter
chmod -R 775 /home/jupyter
chmod g+s /home/jupyter

# Function to setup zsh for a user
setup_zsh_for_user() {
    local username=$1
    
    echo "🔧 Setting up zsh for user: $username"
    
    # Add user to jupyter-users group for access to /home/jupyter
    usermod -aG jupyter-users "$username" 2>/dev/null || true
    
    # Change default shell
    chsh -s /bin/zsh "$username" 2>/dev/null || true
    
    # Install oh-my-zsh (skip if already installed)
    if [ ! -d "/home/$username/.oh-my-zsh" ]; then
        su - "$username" -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
        
        # Install plugins
        su - "$username" -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true'
        su - "$username" -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true'

        # Start in /home/jupyter directory (only for non-jupyter users)
        if [ "$username" != "jupyter" ]; then
            su - "$username" -c 'echo "cd /home/jupyter" >> ~/.zshrc'
            # Auto-launch zsh from bash because default shell change does not work
            su - "$username" -c 'echo "[ -f /bin/zsh ] && exec /bin/zsh" >> ~/.bashrc'
        fi

        # Fix permissions: Remove group write from .oh-my-zsh to satisfy security check
        chmod -R g-w "/home/$username/.oh-my-zsh"
        
        echo "✅ Zsh setup complete for $username"
    else
        echo "ℹ️  oh-my-zsh already installed for $username, skipping..."
        # Still fix permissions if already exists
        chmod -R g-w "/home/$username/.oh-my-zsh"
    fi

    # Initialize conda for zsh and activate base environment
    # If you want another env from jupyter (e.g. pytorch) you may want to modify or delete this block
    if [ -f "/opt/conda/bin/conda" ]; then
        echo "🐍 Initializing conda for $username..."
        su - "$username" -c '/opt/conda/bin/conda init zsh 2>/dev/null || true'
        # Ensure base environment is activated by default (only add if not already present)
        if ! su - "$username" -c 'grep -q "^conda activate base" ~/.zshrc 2>/dev/null'; then
            su - "$username" -c 'echo "conda activate base" >> ~/.zshrc'
        fi
    fi

    # Change theme to fox
    su - "$username" -c "sed -i 's/ZSH_THEME=\".*\"/ZSH_THEME=\"fox\"/' ~/.zshrc"
    
    # Update plugins
    su - "$username" -c "sed -i 's/plugins=(git)/plugins=(git docker kubectl python pip zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc"
}

# Configure Jupyter to use zsh in terminals (append, don't overwrite)
mkdir -p /home/jupyter/.jupyter
if ! grep -q "terminado_settings" /home/jupyter/.jupyter/jupyter_notebook_config.py 2>/dev/null; then
    cat >> /home/jupyter/.jupyter/jupyter_notebook_config.py <<'EOF'

# Set zsh as the terminal shell
c.NotebookApp.terminado_settings = {'shell_command': ['/bin/zsh']}
EOF
fi

# Set JupyterLab theme to dark
echo "🌙 Setting JupyterLab theme to dark..."
mkdir -p /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/apputils-extension
cat > /home/jupyter/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings <<'EOF'
{
    "theme": "JupyterLab Dark"
}
EOF
chown -R jupyter:jupyter-users /home/jupyter/.jupyter

# Setup zsh for all users in /home with UID >= 1000 (non-system users)
echo "🔍 Scanning for users to setup..."
for user_home in /home/*; do
    if [ -d "$user_home" ]; then
        username=$(basename "$user_home")
        user_id=$(id -u "$username" 2>/dev/null)
        
        # Only setup for non-system users (UID >= 1000)
        if [ ! -z "$user_id" ] && [ "$user_id" -ge 1000 ]; then
            setup_zsh_for_user "$username"
        fi
    fi
done

# Restart Jupyter service to apply changes
systemctl restart jupyter.service

echo "✅ Zsh and oh-my-zsh setup complete for all users!"