# ============================================
# Vertex AI Workbench Management Functions
# ============================================
#
# CONFIGURATION REQUIRED:
# This plugin requires WB_INSTANCES to be defined in your ~/.zshrc
# before loading Oh My Zsh. Example:
#
#   typeset -A WB_INSTANCES
#   WB_INSTANCES=(
#     instance-name "us-west1-a"
#     another-instance "us-central1-a"
#   )
#
# ============================================

# Validate that WB_INSTANCES is configured
_wb-check-config() {
  if [[ -z "${WB_INSTANCES[(I)*]}" ]]; then
    echo "❌ ERROR: gcloud-vertex-workbench plugin requires WB_INSTANCES to be defined in ~/.zshrc"
    echo ""
    echo "Please add the following to your ~/.zshrc before 'source \$ZSH/oh-my-zsh.sh':"
    echo ""
    echo "  typeset -A WB_INSTANCES"
    echo "  WB_INSTANCES=("
    echo "    instance-name \"us-west1-a\""
    echo "    another-instance \"us-central1-a\""
    echo "  )"
    echo ""
    return 1
  fi
  return 0
}

# Get instance location from hardcoded map
wb-get-location() {
  local instance_name=$1
  echo "${WB_INSTANCES[$instance_name]}"
}

# Start workbench instance
wb-start() {
  _wb-check-config || return 1
  
  local instance_name=$1
  if [ -z "$instance_name" ]; then
    echo "Usage: wb-start INSTANCE_NAME"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  local location=$(wb-get-location "$instance_name")
  if [ -z "$location" ]; then
    echo "Error: Instance '$instance_name' not found in configuration"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  echo "🚀 Starting $instance_name in $location..."
  gcloud workbench instances start "$instance_name" --location="$location" --quiet \
  && echo "✅ Started $instance_name in $location"
}

# Stop workbench instance
wb-stop() {
  _wb-check-config || return 1
  
  local instance_name=$1
  if [ -z "$instance_name" ]; then
    echo "Usage: wb-stop INSTANCE_NAME"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  local location=$(wb-get-location "$instance_name")
  if [ -z "$location" ]; then
    echo "Error: Instance '$instance_name' not found in configuration"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  echo "🛑 Stopping $instance_name in $location..."
  gcloud workbench instances stop "$instance_name" --location="$location" --quiet \
  && echo "✅ Stopped $instance_name in $location"
}

# Restart workbench instance
wb-restart() {
  local instance_name=$1
  if [ -z "$instance_name" ]; then
    echo "Usage: wb-restart INSTANCE_NAME"
    return 1
  fi
  
  echo "🔄 Restarting $instance_name..."
  wb-stop "$instance_name" && wb-start "$instance_name"
}

# Get instance status
wb-status() {
  _wb-check-config || return 1
  
  local instance_name=$1
  if [ -z "$instance_name" ]; then
    echo "Usage: wb-status INSTANCE_NAME"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  local location=$(wb-get-location "$instance_name")
  if [ -z "$location" ]; then
    echo "Error: Instance '$instance_name' not found in configuration"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  gcloud workbench instances describe "$instance_name" \
    --location="$location" \
    --format="table(name,location,state,healthState)"
}

# Get instance details
wb-info() {
  _wb-check-config || return 1
  
  local instance_name=$1
  if [ -z "$instance_name" ]; then
    echo "Usage: wb-info INSTANCE_NAME"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  local location=$(wb-get-location "$instance_name")
  if [ -z "$location" ]; then
    echo "Error: Instance '$instance_name' not found in configuration"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  gcloud workbench instances describe "$instance_name" \
    --location="$location"
}

# Get instance URL
wb-url() {
  _wb-check-config || return 1
  
  local instance_name=$1
  if [ -z "$instance_name" ]; then
    echo "Usage: wb-url INSTANCE_NAME"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  local location=$(wb-get-location "$instance_name")
  if [ -z "$location" ]; then
    echo "Error: Instance '$instance_name' not found in configuration"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  local url=$(gcloud workbench instances describe "$instance_name" \
    --location="$location" \
    --format="value(proxyUri)")
  
  echo "$url"
  
  # Optionally open in browser (uncomment if desired)
  # open "$url"  # macOS
  # xdg-open "$url"  # Linux
}

# SSH into instance
wb-ssh() {
  _wb-check-config || return 1
  
  local instance_name=$1
  if [ -z "$instance_name" ]; then
    echo "Usage: wb-ssh INSTANCE_NAME"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  local location=$(wb-get-location "$instance_name")
  if [ -z "$location" ]; then
    echo "Error: Instance '$instance_name' not found in configuration"
    echo "Available instances: ${(k)WB_INSTANCES}"
    return 1
  fi
  
  if [ -z "$GCLOUD_DEFAULT_PROJECT" ]; then
    echo "❌ Error: GCLOUD_DEFAULT_PROJECT environment variable is not set"
    echo "Please set it in your ~/.zshrc: export GCLOUD_DEFAULT_PROJECT=\"your-project-id\""
    return 1
  fi
  
  echo "🔌 Connecting to $instance_name via IAP tunnel..."
  gcloud compute ssh "$instance_name" \
    --project="$GCLOUD_DEFAULT_PROJECT" \
    --zone="$location" \
    --tunnel-through-iap
}

# List configured instances
wb-list() {
  _wb-check-config || return 1
  
  echo "Configured instances:"
  for instance location in ${(kv)WB_INSTANCES}; do
    echo "  $instance -> $location"
  done
  echo ""
  echo "Fetching current status..."
  for instance location in ${(kv)WB_INSTANCES}; do
    local state=$(gcloud workbench instances describe "$instance" \
      --location="$location" \
      --format="value(state)" 2>/dev/null || echo "ERROR")
    printf "  %-20s %-15s %s\n" "$instance" "$location" "$state"
  done
}

# Start all configured instances
wb-start-all() {
  _wb-check-config || return 1
  
  echo "🚀 Starting all configured instances..."
  for instance location in ${(kv)WB_INSTANCES}; do
    echo "Starting $instance in $location..."
    gcloud workbench instances start "$instance" --location="$location"
  done
}

# Stop all configured instances
wb-stop-all() {
  _wb-check-config || return 1
  
  echo "🛑 Stopping all configured instances..."
  for instance location in ${(kv)WB_INSTANCES}; do
    echo "Stopping $instance in $location..."
    gcloud workbench instances stop "$instance" --location="$location"
  done
}

# Show help
wb-help() {
  _wb-check-config || return 1
  
  cat << 'EOF'
Vertex AI Workbench Management Commands:

  wb-list              List configured instances with status
  
  wb-start NAME        Start instance by name
  wb-stop NAME         Stop instance by name
  wb-status NAME       Get instance status
  wb-info NAME         Get detailed instance info
  wb-url NAME          Get instance JupyterLab URL
  wb-ssh NAME          SSH into instance
  
  wb-start-all         Start all configured instances
  wb-stop-all          Stop all configured instances
  
  wb-help              Show this help message

EOF
  echo "Configured instances:"
  for instance location in ${(kv)WB_INSTANCES}; do
    echo "  - $instance ($location)"
  done
  echo ""
  echo "Examples:"
  echo "  wb-start jn1"
  echo "  wb-status ec-ml-4-gpu"
  echo "  wb-ssh jn1"
}
