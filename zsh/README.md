# Zsh Configuration for macOS

Custom Zsh configuration with Oh My Zsh integration, featuring Google Cloud Platform shortcuts and Vertex AI Workbench management tools.

> **⚠️ Important:** This configuration requires customization before use. You must edit `dotfiles/zshrc` to add your own GCP account, projects, and Vertex AI Workbench instances. See [Configuration](#configuration) section below.

## Overview

This configuration provides a streamlined terminal experience for working with Google Cloud Platform:

- **GCP Shortcuts** - Quick aliases for switching projects and accounts
- **Vertex AI Workbench Management** - CLI commands to start, stop, and manage workbench instances
- **dbt Aliases** - Streamlined data build tool testing (optional, can be removed if not needed)
- **Cursor IDE Integration** - Auto-start workbench instances and open remote workspaces
- **Custom Oh My Zsh Plugin** - Reusable plugin for workbench management that handles instance lifecycle

## Who Is This For?

This configuration is useful if you:
- Work with multiple Google Cloud Platform projects
- Use Vertex AI Workbench instances for ML/data science work
- Want to quickly start/stop instances from the terminal to save costs
- Use Cursor IDE for remote development on workbench instances
- Use dbt (data build tool) for data transformations
- Want a consistent terminal setup across machines

## Installation

1. Ensure Oh My Zsh is installed:
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

2. Clone or download this repository to your preferred location:
   ```bash
   # Example:
   git clone <repository-url> ~/dotfiles/zsh
   # or download and extract to your preferred directory
   ```

3. **IMPORTANT:** Customize the configuration for your environment:
   - Edit `dotfiles/zshrc` and update:
     - `GCLOUD_DEFAULT_ACCOUNT` with your GCP account email
     - `GCLOUD_DEFAULT_PROJECT` with your default GCP project
     - `GCLOUD_DEFAULT_PROD_PROJECT` with your production GCP project (if applicable)
     - `WB_INSTANCES` with your Vertex AI Workbench instances and their zones
   - Remove or modify any personal aliases in `dotfiles/oh-my-zsh-custom/aliases.zsh`

4. Run the installation script from the zsh directory:
   ```bash
   cd /path/to/this/repo/zsh
   ./install_zsh_custom.sh
   ```

5. Reload your shell configuration:
   ```bash
   source ~/.zshrc
   ```

The installation script will:
- Backup existing `~/.oh-my-zsh/custom` and `~/.zshrc` files (with `.backup` extension)
- Create symlinks to the dotfiles in this repository

## Configuration

### Environment Variables

**Before using this configuration, customize these variables in `dotfiles/zshrc`:**

```bash
# Replace with your GCP account email
export GCLOUD_DEFAULT_ACCOUNT="your-email@your-org.com"

# Replace with your default GCP project ID
export GCLOUD_DEFAULT_PROJECT="your-project-id"

# Replace with your production GCP project ID (optional)
export GCLOUD_DEFAULT_PROD_PROJECT="your-prod-project-id"
```

### Vertex AI Workbench Instances

Define your Vertex AI Workbench instances in `dotfiles/zshrc`:

```bash
typeset -A WB_INSTANCES
WB_INSTANCES=(
  instance-name-1 "us-west1-a"
  instance-name-2 "us-central1-a"
  ml-workbench "europe-west1-b"
  # Add your instances here: "instance-name" "zone"
)
```

**Note:** Each instance requires two values:
1. The instance name (as it appears in GCP)
2. The zone where the instance is located

## Features

### 1. GCP Aliases

Quick commands for switching GCP configuration:

- **`gcp-project`** - Set GCP project to your default project (from `$GCLOUD_DEFAULT_PROJECT`)
- **`gcp-account`** - Set GCP account to your default account (from `$GCLOUD_DEFAULT_ACCOUNT`)

Example:
```bash
gcp-project  # Sets: gcloud config set project $GCLOUD_DEFAULT_PROJECT
gcp-account  # Sets: gcloud config set account $GCLOUD_DEFAULT_ACCOUNT
```

### 2. dbt Aliases

Streamlined dbt testing commands with 50 threads:

- **`dbtr TABLE_NAME`** - Run dbt tests for a specific table (staging/default target)
- **`dbtt TABLE_NAME`** - Run dbt tests for a specific table (staging/default target)
- **`dbtrp TABLE_NAME`** - Run dbt tests against production project
- **`dbttp TABLE_NAME`** - Run dbt tests against production project

Example:
```bash
dbtr my_model      # Test a model in your default environment
dbttp my_model     # Test a model in production
```

**Note:** These aliases are configured for dbt users. If you don't use dbt, you can remove or modify them in `dotfiles/oh-my-zsh-custom/aliases.zsh`.

### 3. Vertex AI Workbench Management

#### Cursor Workspace Integration

**`cwb INSTANCE_NAME`** - Open Cursor workspace for a Vertex AI Workbench instance

Features:
- Automatically checks instance status using gcloud
- Starts the instance if it's stopped
- Waits for the instance to become active (up to 5 minutes)
- Opens the corresponding Cursor workspace file from `~/cursor/vertex_workbench/`

Example:
```bash
cwb my-workbench  # Opens ~/cursor/vertex_workbench/my-workbench.code-workspace
```

**Prerequisites:**
- Cursor IDE installed
- Workspace files created at `~/cursor/vertex_workbench/INSTANCE_NAME.code-workspace`
- Instance name must be defined in `WB_INSTANCES` configuration

#### Workbench CLI Commands

The custom `gcloud-vertex-workbench` plugin provides comprehensive instance management:

**Instance Control:**
- `wb-start INSTANCE_NAME` - Start a workbench instance
- `wb-stop INSTANCE_NAME` - Stop a workbench instance
- `wb-restart INSTANCE_NAME` - Restart a workbench instance

**Instance Information:**
- `wb-status INSTANCE_NAME` - Get instance status table
- `wb-info INSTANCE_NAME` - Get detailed instance information
- `wb-url INSTANCE_NAME` - Get JupyterLab proxy URL
- `wb-ssh INSTANCE_NAME` - SSH into instance via IAP tunnel

**Bulk Operations:**
- `wb-list` - List all configured instances with current status
- `wb-start-all` - Start all configured instances
- `wb-stop-all` - Stop all configured instances

**Help:**
- `wb-help` - Display help message with all available commands

Example usage:
```bash
# Start an instance
wb-start my-workbench

# Check status
wb-status my-workbench

# SSH into instance (via IAP tunnel)
wb-ssh my-workbench

# Get JupyterLab URL
wb-url my-workbench

# List all configured instances with their current status
wb-list

# Stop all instances (useful for cost savings)
wb-stop-all
```

## File Structure

```
zsh/
├── install_zsh_custom.sh              # Installation script
└── dotfiles/
    ├── zshrc                          # Main zsh configuration
    └── oh-my-zsh-custom/
        ├── aliases.zsh                # Custom aliases
        ├── settings.zsh               # Theme and display settings
        └── plugins/
            └── gcloud-vertex-workbench/
                ├── gcloud-vertex-workbench.plugin.zsh  # Workbench management plugin
                └── README.md                            # Plugin documentation
```

## Customization

### Adding Workbench Instances

To add new Vertex AI Workbench instances, edit `dotfiles/zshrc`:

```bash
typeset -A WB_INSTANCES
WB_INSTANCES=(
  dev-workbench "us-west1-a"
  prod-ml "us-central1-a"
  gpu-instance "europe-west4-b"
  # Add more as needed: instance-name "zone"
)
```

To find your instance names and zones:
```bash
gcloud workbench instances list --format="table(name,location)"
```

### Adding Custom Aliases

Add your own aliases to `dotfiles/oh-my-zsh-custom/aliases.zsh`:

```bash
# Example: Quick directory navigation
alias myproject="cd ~/projects/my-project"

# Example: Git shortcuts
alias gst="git status"
alias gco="git checkout"

# Example: Custom scripts
alias deploy="./scripts/deploy.sh"
```

### Changing Theme

Edit `dotfiles/oh-my-zsh-custom/settings.zsh`:

```bash
ZSH_THEME="your-preferred-theme"
```

Popular themes: `robbyrussell`, `agnoster`, `powerlevel10k`, `spaceship`

See all available themes: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

### Modifying or Removing dbt Aliases

If you don't use dbt, you can:
1. Remove the dbt aliases section from `dotfiles/oh-my-zsh-custom/aliases.zsh`
2. Replace them with your own tool-specific aliases (e.g., for Terraform, kubectl, docker)

## Dependencies

- **Oh My Zsh** - Framework for managing Zsh configuration
- **Google Cloud SDK** - For `gcloud` commands
- **Cursor** - Code editor (for `cwb` alias)
- **dbt** - Data build tool (for dbt aliases)

## Notes

- The installation script creates backups with `.backup` extension before overwriting files
- Configuration uses symlinks, so changes to files in this repo are reflected immediately (no need to reinstall)
- The `gcloud-vertex-workbench` plugin requires `WB_INSTANCES` to be defined before loading Oh My Zsh
- SSH connections use IAP tunnel and require `GCLOUD_DEFAULT_PROJECT` to be set
- You can safely modify the configuration files without affecting the original backups

## Troubleshooting

### "Plugin not loading" or "WB_INSTANCES not defined" error

**Issue:** The `gcloud-vertex-workbench` plugin shows an error on shell startup.

**Solution:** Ensure `WB_INSTANCES` is defined in `dotfiles/zshrc` **before** the line `source $ZSH/oh-my-zsh.sh`. The order matters!

```bash
# ✅ Correct order in dotfiles/zshrc:
export GCLOUD_DEFAULT_PROJECT="..."
typeset -A WB_INSTANCES
WB_INSTANCES=(...)
plugins=(git gcloud macos gcloud-vertex-workbench)
source $ZSH/oh-my-zsh.sh

# ❌ Wrong - variables defined after sourcing Oh My Zsh
```

### Cursor workspaces not found

**Issue:** `cwb` command says workspace file not found.

**Solution:** The `cwb` command expects workspace files at:
```
~/cursor/vertex_workbench/INSTANCE_NAME.code-workspace
```

Create this directory and workspace files, or modify the `cwb` function in `aliases.zsh` to point to your preferred location.

### SSH connection fails

**Issue:** `wb-ssh` command fails to connect.

**Solutions:**
1. Verify the instance is running: `wb-status INSTANCE_NAME`
2. Check your GCP project is set: `echo $GCLOUD_DEFAULT_PROJECT`
3. Ensure you have IAP permissions for the project:
   ```bash
   gcloud projects get-iam-policy $GCLOUD_DEFAULT_PROJECT --flatten="bindings[].members" --format="table(bindings.role)" --filter="bindings.members:$(gcloud config get-value account)"
   ```
4. Verify the zone is correct in `WB_INSTANCES`
5. Test basic gcloud connectivity: `gcloud compute instances list`

### Commands not found after installation

**Issue:** New commands like `wb-start` or `gcp-project` don't work.

**Solutions:**
1. Reload your shell: `source ~/.zshrc`
2. Verify symlinks were created:
   ```bash
   ls -la ~/.zshrc
   ls -la ~/.oh-my-zsh/custom
   ```
3. Check for syntax errors: `zsh -n ~/.zshrc`

### "Instance not found in configuration" error

**Issue:** Commands like `wb-start my-instance` say the instance isn't configured.

**Solutions:**
1. List configured instances: `wb-list` or `echo ${(k)WB_INSTANCES}`
2. Add the instance to `WB_INSTANCES` in `dotfiles/zshrc`
3. Reload your shell after editing: `source ~/.zshrc`

## Uninstalling

To remove this configuration:

```bash
# Remove symlinks
rm ~/.zshrc
rm ~/.oh-my-zsh/custom

# Restore backups
mv ~/.zshrc.backup ~/.zshrc
mv ~/.oh-my-zsh/custom.backup ~/.oh-my-zsh/custom

# Reload shell
source ~/.zshrc
```

## Contributing

This is a personal configuration repository, but feel free to:
- Fork it and adapt it to your needs
- Submit issues if you find bugs
- Share improvements or suggestions

## License

MIT License - Use at your own discretion. No warranty provided.

