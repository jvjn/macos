alias ls="ls -lGha"

# Google Cloud Platform configuration aliases
alias gcp-project="gcloud config set project $GCLOUD_DEFAULT_PROJECT"
alias gcp-account="gcloud config set account $GCLOUD_DEFAULT_ACCOUNT"
alias gcp-auth="gcloud auth application-default login --scopes=https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/drive,https://www.googleapis.com/auth/bigquery"


# dbt aliases
dbtr() {
  if [ -z "$1" ]; then
    echo "Usage: dbttp TABLE_NAME"
    return 1
  fi
  dbt test --select "$1" --threads 50
}

dbtt() {
  if [ -z "$1" ]; then
    echo "Usage: dbttp TABLE_NAME"
    return 1
  fi
  dbt test --select "$1" --threads 50
}

dbtrp() {
  if [ -z "$1" ]; then
    echo "Usage: dbttp TABLE_NAME"
    return 1
  fi
  dbt test --select "$1" --target "$GCLOUD_DEFAULT_PROD_PROJECT" --threads 50
}

dbttp() {
  if [ -z "$1" ]; then
    echo "Usage: dbttp TABLE_NAME"
    return 1
  fi
  dbt test --select "$1" --target "$GCLOUD_DEFAULT_PROD_PROJECT" --threads 50
}

# Cursor Vertex AI Workbench aliases
cwb() {
  if [ -z "$1" ]; then
    echo "Usage: cwb INSTANCE_NAME"
    echo "Available workspaces:"
    ls -1 ~/.cursor/workspaces/vertex_workbench/*.code-workspace 2>/dev/null | xargs -n 1 basename | sed 's/.code-workspace$//'
    return 1
  fi
  
  local instance_name=$1
  local workspace_file=~/.cursor/workspaces/vertex_workbench/"$instance_name".code-workspace
  
  if [ ! -f "$workspace_file" ]; then
    echo "❌ Error: Workspace file not found: $workspace_file"
    echo ""
    echo "Available workspaces:"
    ls -1 ~/.cursor/workspaces/vertex_workbench/*.code-workspace 2>/dev/null | xargs -n 1 basename | sed 's/.code-workspace$//'
    return 1
  fi
  
  # Check if WB_INSTANCES is configured
  if [[ -n "${WB_INSTANCES[(I)*]}" ]]; then
    local location=$(echo "${WB_INSTANCES[$instance_name]}")
    
    if [ -n "$location" ]; then
      echo "🔍 Checking instance status..."
      local state=$(gcloud workbench instances describe "$instance_name" \
        --location="$location" \
        --format="value(state)" 2>/dev/null)
      
      if [ "$state" = "ACTIVE" ]; then
        echo "✅ Instance $instance_name is running"
      elif [ "$state" = "STOPPED" ]; then
        echo "⏸️  Instance $instance_name is stopped, starting it now..."
        gcloud workbench instances start "$instance_name" --location="$location"
        
        echo "⏳ Waiting for instance to become active..."
        local max_attempts=60
        local attempt=0
        while [ $attempt -lt $max_attempts ]; do
          sleep 5
          attempt=$((attempt + 1))
          state=$(gcloud workbench instances describe "$instance_name" \
            --location="$location" \
            --format="value(state)" 2>/dev/null)
          
          if [ "$state" = "ACTIVE" ]; then
            echo "✅ Instance is now active!"
            sleep 5  # Brief pause to ensure SSH is ready
            break
          else
            echo "   Status: $state (attempt $attempt/$max_attempts)"
          fi
        done
        
        if [ "$state" != "ACTIVE" ]; then
          echo "⚠️  Warning: Instance did not become active within expected time"
          echo "   Current state: $state"
          echo "   Proceeding anyway, but connection may fail..."
        fi
      else
        echo "⚠️  Instance state: $state"
      fi
    fi
  fi
  
  echo "🚀 Opening Cursor workspace for $instance_name..."
  open -a "Cursor" "$workspace_file"
}
