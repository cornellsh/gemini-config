#!/bin/bash
set -e

# Configuration
CONFIG_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GEMINI_DIR="$HOME/.gemini" # Defaulting to global gemini dir, or use CWD relative
# However, the previous script used CWD. 
# To make this shareable, let's assume the user runs this inside their *project* 
# where they want to USE this config, OR this sets up the config repo itself.
# Re-reading prompt: "make the current gemini-config fully reproducible... ready for other senior developers to use"
# "Setup script... Is the sole entry point for setting up gemini-config on any machine."

# We will treat the current directory (gemini-config) as the source.
# The user likely clones this repo to `~/.gemini-config` or similar, 
# then symlinks or copies to `~/.gemini`.
# OR, this script initializes the CURRENT directory to be ready for work.

# Let's assume the standard use case: 
# 1. Clone this repo.
# 2. Run ./scripts/setup.sh
# 3. Point Gemini CLI to this user-config.

# Ensure we are in the repo root
cd "$CONFIG_ROOT"

echo "🚀 Initializing Elite TUI Gemini Configuration (v1.1)..."

# 1. Dependency Checks
echo "🔍 Checking dependencies..."

if ! command -v rg &> /dev/null; then
    echo "❌ 'rg' (ripgrep) not found. Required for 'tech-debt-tracker' and 'search_file_content'."
    echo "   Please install: brew install ripgrep / apt-get install ripgrep"
    exit 1
fi

echo "✅ Dependencies verified."

# 2. Initialize Session State Structure
# We put .gemini in the root of the config repo for self-hosting logic, 
# but effectively, when using this config, the .gemini folder should be in the PROJECT root.
# This script sets up the local repo for use/development.

GEMINI_LOCAL_DIR=".gemini"
mkdir -p "$GEMINI_LOCAL_DIR"

SESSION_PLAN_JSON="$GEMINI_LOCAL_DIR/SESSION_PLAN.json"
SESSION_PLAN_MD="$GEMINI_LOCAL_DIR/SESSION_PLAN.md"

if [ ! -f "$SESSION_PLAN_JSON" ]; then
  echo "📄 Creating default SESSION_PLAN.json..."
  cat > "$SESSION_PLAN_JSON" <<EOF
{
  "version": "1.1",
  "project_root": "$(pwd)",
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "updated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "tasks": [],
  "context_snapshots": {
    "module_graph": { "hash": null, "updated_at": null },
    "project_state": { "hash": null, "updated_at": null }
  },
  "active_agent": null
}
EOF
else
  echo "⏩ SESSION_PLAN.json exists. Skipping."
fi

if [ ! -f "$SESSION_PLAN_MD" ]; then
  echo "📄 Creating default SESSION_PLAN.md..."
  cat > "$SESSION_PLAN_MD" <<EOF
# Gemini Session Plan

**Status:** Initialized
**Updated:** $(date -u +"%Y-%m-%dT%H:%M:%SZ")

## Active Tasks
| ID | Title | Status | Assigned To | Priority | Dependencies |
| :--- | :--- | :--- | :--- | :--- | :--- |
| - | No active tasks | - | - | - | - |

## Context Snapshots
- **Module Graph:** Pending
- **Project State:** Pending
EOF
else
  echo "⏩ SESSION_PLAN.md exists. Skipping."
fi

# 3. Permissions
echo "🔐 Setting permissions..."
chmod +x scripts/*.sh 2>/dev/null || true

echo "🎉 Setup complete!"
echo "   To use this configuration:"
echo "   1. Ensure your 'gemini' CLI is installed."
echo "   2. Configure gemini to use $(pwd)/user-config"
echo "   3. Run 'gemini chat' and type '/refactor' to start."
