# Google Cloud Vertex AI Workbench Plugin

A ZSH plugin for managing Google Cloud Vertex AI Workbench instances through convenient command-line shortcuts.

## Features

This plugin provides a set of easy-to-use commands for managing your Vertex AI Workbench instances:

- 🚀 Start/stop instances
- 📊 Check instance status
- 📝 Get detailed instance information
- 🔗 Retrieve JupyterLab URLs
- 🔌 SSH into instances via IAP tunnel
- 📋 List all configured instances
- ⚡ Batch operations (start/stop all)

## Prerequisites

- **Google Cloud SDK (`gcloud`)**: Must be installed and authenticated
- **Oh My Zsh**: This is an Oh My Zsh custom plugin
- **Active GCP Project**: With Vertex AI Workbench enabled
- **IAM Permissions**: Appropriate permissions to manage Workbench instances

## Installation

### 1. Install the Plugin

Copy this plugin directory to your Oh My Zsh custom plugins directory:

```bash
cp -r gcloud-vertex-workbench ~/.oh-my-zsh/custom/plugins/
```

### 2. Configure Your Instances

Add the following to your `~/.zshrc` **before** the `source $ZSH/oh-my-zsh.sh` line:

```bash
# Define your Workbench instances
typeset -A WB_INSTANCES
WB_INSTANCES=(
  instance-name-1 "us-west1-a"
  instance-name-2 "us-central1-a"
  my-gpu-workbench "us-east1-b"
)

# Required for SSH functionality
export GCLOUD_DEFAULT_PROJECT="your-gcp-project-id"
```

### 3. Enable the Plugin

Add `gcloud-vertex-workbench` to your plugins array in `~/.zshrc`:

```bash
plugins=(
  git
  gcloud-vertex-workbench
  # ... other plugins
)
```

### 4. Reload Your Shell

```bash
source ~/.zshrc
```

## Configuration

### WB_INSTANCES

The `WB_INSTANCES` associative array maps instance names to their GCP locations (zones):

```bash
typeset -A WB_INSTANCES
WB_INSTANCES=(
  instance-name "zone"
  # Examples:
  jn1 "us-west1-a"
  ml-workbench "us-central1-c"
  gpu-instance "europe-west4-a"
)
```

### GCLOUD_DEFAULT_PROJECT (Required for SSH)

Set your default GCP project ID for SSH connections:

```bash
export GCLOUD_DEFAULT_PROJECT="my-project-123456"
```

## Commands

### Instance Management

#### `wb-start NAME`
Start a Workbench instance.

```bash
wb-start jn1
# 🚀 Starting jn1 in us-west1-a...
# ✅ Started jn1 in us-west1-a
```

#### `wb-stop NAME`
Stop a Workbench instance.

```bash
wb-stop jn1
# 🛑 Stopping jn1 in us-west1-a...
# ✅ Stopped jn1 in us-west1-a
```

#### `wb-restart NAME`
Restart a Workbench instance (stop then start).

```bash
wb-restart jn1
# 🔄 Restarting jn1...
```

### Instance Information

#### `wb-status NAME`
Get the current status of an instance.

```bash
wb-status jn1
# NAME  LOCATION    STATE   HEALTH_STATE
# jn1   us-west1-a  ACTIVE  HEALTHY
```

#### `wb-info NAME`
Get detailed information about an instance.

```bash
wb-info jn1
# (Returns full instance details in YAML format)
```

#### `wb-url NAME`
Get the JupyterLab URL for an instance.

```bash
wb-url jn1
# https://xxxxx.notebooks.googleusercontent.com/
```

### SSH Access

#### `wb-ssh NAME`
SSH into a Workbench instance via IAP tunnel.

```bash
wb-ssh jn1
# 🔌 Connecting to jn1 via IAP tunnel...
# (Establishes SSH connection)
```

**Note:** Requires `GCLOUD_DEFAULT_PROJECT` to be set.

### Batch Operations

#### `wb-list`
List all configured instances with their current status.

```bash
wb-list
# Configured instances:
#   jn1 -> us-west1-a
#   ml-workbench -> us-central1-c
#
# Fetching current status...
#   jn1                  us-west1-a      ACTIVE
#   ml-workbench         us-central1-c   STOPPED
```

#### `wb-start-all`
Start all configured instances.

```bash
wb-start-all
# 🚀 Starting all configured instances...
```

#### `wb-stop-all`
Stop all configured instances.

```bash
wb-stop-all
# 🛑 Stopping all configured instances...
```

### Help

#### `wb-help`
Display help information and available commands.

```bash
wb-help
```

## Usage Examples

### Daily Workflow

```bash
# Morning: Start your workbench
wb-start jn1

# Get the JupyterLab URL
wb-url jn1

# Check if it's running
wb-status jn1

# Evening: Stop to save costs
wb-stop jn1
```

### Managing Multiple Instances

```bash
# See all your instances and their status
wb-list

# Start a specific GPU instance for training
wb-start gpu-instance

# SSH into the instance for debugging
wb-ssh gpu-instance

# When done, stop all instances
wb-stop-all
```

### Troubleshooting

```bash
# Check detailed instance information
wb-info jn1

# Restart if instance is unhealthy
wb-restart jn1

# Verify all instances are stopped
wb-list
```

## Error Handling

The plugin includes built-in validation:

- ✅ Checks if `WB_INSTANCES` is configured
- ✅ Validates instance names against configured instances
- ✅ Provides helpful error messages with available instances
- ✅ Checks for required environment variables (e.g., `GCLOUD_DEFAULT_PROJECT` for SSH)

### Common Errors

**Instance not configured:**
```bash
wb-start unknown-instance
# Error: Instance 'unknown-instance' not found in configuration
# Available instances: jn1 ml-workbench gpu-instance
```

**Missing configuration:**
```bash
# If WB_INSTANCES is not defined
wb-start jn1
# ❌ ERROR: gcloud-vertex-workbench plugin requires WB_INSTANCES to be defined in ~/.zshrc
# (Provides configuration example)
```

## Tips

1. **Cost Optimization**: Use `wb-stop-all` to stop all instances when not in use
2. **Quick Access**: Create shell aliases for frequently used instances
3. **Monitoring**: Run `wb-list` periodically to ensure instances aren't running unnecessarily
4. **Tab Completion**: ZSH will autocomplete the `wb-*` commands

## License

This plugin is part of a personal macOS configuration repository.

## Contributing

This is a custom plugin for personal use. Feel free to fork and adapt to your needs.

## Author

Created for managing Vertex AI Workbench instances efficiently from the command line.

