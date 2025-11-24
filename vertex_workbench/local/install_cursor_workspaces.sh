#!/bin/bash

# Create ~/.cursor/workspaces directory if it doesn't exist
if [ ! -d ~/.cursor/workspaces ]; then
  echo "📁 Creating ~/.cursor/workspaces directory..."
  mkdir -p ~/.cursor/workspaces
fi

# Remove ~/.cursor/workspaces/vertex_workbench if it exists (file or symlink)
if [ -e ~/.cursor/workspaces/vertex_workbench ] || [ -L ~/.cursor/workspaces/vertex_workbench ]; then
  echo "🗑️  Removing existing ~/.cursor/workspaces/vertex_workbench..."
  rm -rf ~/.cursor/workspaces/vertex_workbench
fi

# Symlink the entire cursor/workspaces directory
echo "🔗 Symlinking Cursor workspaces directory..."
ln -s "$(pwd)/cursor/workspaces" ~/.cursor/workspaces/vertex_workbench

echo ""
echo "✅ Cursor workspace configuration complete!"
echo "Workspace files are now available in ~/.cursor/workspaces/vertex_workbench/"
echo "Any new .code-workspace files added to cursor/workspaces/ will automatically appear!"
echo ""
echo "💡 Use the 'cwb' command to open workspaces:"
echo "   cwb jn1"
echo "   cwb jvjn-ml-1"
