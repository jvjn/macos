#!/bin/bash

# Create ~/cursor directory if it doesn't exist
if [ ! -d ~/cursor ]; then
  echo "📁 Creating ~/cursor directory..."
  mkdir -p ~/cursor
fi

# Remove ~/cursor/vertex_workbench if it exists (file or symlink)
if [ -e ~/cursor/vertex_workbench ] || [ -L ~/cursor/vertex_workbench ]; then
  echo "🗑️  Removing existing ~/cursor/vertex_workbench..."
  rm -rf ~/cursor/vertex_workbench
fi

# Symlink the entire cursor/workspaces directory
echo "🔗 Symlinking Cursor workspaces directory..."
ln -s "$(pwd)/cursor/workspaces" ~/cursor/vertex_workbench

echo ""
echo "✅ Cursor workspace configuration complete!"
echo "Workspace files are now available in ~/cursor/vertex_workbench/"
echo "Any new .code-workspace files added to cursor/workspaces/ will automatically appear!"
