#!/bin/bash
set -e

# Configuration
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USER_CONFIG_SRC="$REPO_ROOT/user-config"
GLOBAL_GEMINI_DIR="$HOME/.gemini"
LOCAL_GEMINI_DIR="$REPO_ROOT/.gemini"

# --- Functions ---

print_header() {
    echo "========================================================"
    echo "Elite TUI Gemini Configuration Setup (v1.2)"
    echo "Structured Orchestration | Hooks | Policies"
    echo "========================================================"
}

check_dependencies() {
    echo "Checking dependencies..."
    local missing=0

    if ! command -v node &> /dev/null; then
        echo "Error: Node.js not found. Required for Gemini CLI, MCP, and Hooks."
        missing=1
    else
        echo "Node.js found."
    fi

    if ! command -v gemini &> /dev/null; then
        echo "Warning: 'gemini' CLI not found in PATH."
        echo "Install via: npm install -g @google/gemini-cli"
    else
        echo "Gemini CLI found."
    fi

    if ! command -v rg &> /dev/null; then
        echo "Warning: 'rg' (ripgrep) not found. Recommended for performance."
        echo "Install via: brew install ripgrep / sudo apt-get install ripgrep"
    else
        echo "ripgrep found."
    fi

    if [ "$missing" -eq 1 ]; then
        echo "Critical dependencies missing. Please install Node.js."
        exit 1
    fi
}

initialize_local_session() {
    echo "Initializing Local Session State..."
    mkdir -p "$LOCAL_GEMINI_DIR"

    if [ ! -f "$LOCAL_GEMINI_DIR/SESSION_PLAN.json" ]; then
        echo "   Creating SESSION_PLAN.json (v1.2)..."
        cat > "$LOCAL_GEMINI_DIR/SESSION_PLAN.json" <<EOF
{
  "version": "1.2",
  "project_root": "$(pwd)",
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "updated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "tasks": [],
  "context_snapshots": {
    "module_graph": { "hash": null, "updated_at": null },
    "project_state": { "hash": null, "updated_at": null }
  },
  "active_agent": null,
  "mcp_servers": {
    "status": "pending_discovery"
  },
  "tool_state": {
    "active_tools": [],
    "last_tool_usage": null
  },
  "policy_events": [],
  "hook_events": []
}
EOF
    else
        echo "   SESSION_PLAN.json already exists. Skipping."
    fi

    if [ ! -f "$LOCAL_GEMINI_DIR/SESSION_PLAN.md" ]; then
        echo "   Creating SESSION_PLAN.md..."
        cat > "$LOCAL_GEMINI_DIR/SESSION_PLAN.md" <<EOF
# Gemini Session Plan

Status: Initialized
Updated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

## Active Tasks
| ID | Title | Status | Assigned To | Priority | Dependencies |
| :--- | :--- | :--- | :--- | :--- | :--- |
| - | No active tasks | - | - | - | - |

## Context Snapshots
- Module Graph: Pending
- Project State: Pending

## Tool & Policy Status
- MCP Servers: Pending Discovery
- Hooks: Active
- Policies: Enforced
EOF
    else
        echo "   SESSION_PLAN.md already exists. Skipping."
    fi
}

install_global_config() {
    echo ""
    echo "Do you want to install this configuration globally to $GLOBAL_GEMINI_DIR?"
    echo "(This will backup your existing settings and symlink this repo's config)"
    read -p "Install globally? [y/N] " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping global installation."
        return
    fi

    echo "Installing Global Configuration..."
    mkdir -p "$GLOBAL_GEMINI_DIR"
    mkdir -p "$GLOBAL_GEMINI_DIR/skills"
    mkdir -p "$GLOBAL_GEMINI_DIR/context"
    mkdir -p "$GLOBAL_GEMINI_DIR/hooks"
    mkdir -p "$GLOBAL_GEMINI_DIR/policies"
    mkdir -p "$GLOBAL_GEMINI_DIR/commands"

    symlink_file() {
        local src="$1"
        local dest="$2"
        local timestamp=$(date +%Y%m%d_%H%M%S)

        if [ -f "$dest" ] || [ -L "$dest" ]; then
            if [ "$(readlink "$dest")" == "$src" ]; then
                echo "   Skipping $dest (already linked)"
                return
            fi
            echo "   Backing up $(basename "$dest") to .bak"
            mv "$dest" "$dest.$timestamp.bak"
        fi
        ln -sf "$src" "$dest"
        echo "   Linked $(basename "$dest") -> $(basename "$src")"
    }

    symlink_dir_contents() {
        local src_dir="$1"
        local dest_dir="$2"
        mkdir -p "$dest_dir"
        for item in "$src_dir"/*; do
            [ -e "$item" ] || continue
            local item_name=$(basename "$item")
            if [ -d "$item" ]; then
                rm -rf "$dest_dir/$item_name"
                ln -sf "$item" "$dest_dir/$item_name"
                echo "   Linked dir $item_name"
            else
                ln -sf "$item" "$dest_dir/$item_name"
                echo "   Linked file $item_name"
            fi
        done
    }

    symlink_file "$USER_CONFIG_SRC/settings.json" "$GLOBAL_GEMINI_DIR/settings.json"
    symlink_dir_contents "$USER_CONFIG_SRC/skills" "$GLOBAL_GEMINI_DIR/skills"
    rm -rf "$GLOBAL_GEMINI_DIR/context"
    ln -sf "$USER_CONFIG_SRC/context" "$GLOBAL_GEMINI_DIR/context"
    symlink_dir_contents "$USER_CONFIG_SRC/hooks" "$GLOBAL_GEMINI_DIR/hooks"
    symlink_dir_contents "$USER_CONFIG_SRC/policies" "$GLOBAL_GEMINI_DIR/policies"
    symlink_dir_contents "$USER_CONFIG_SRC/commands" "$GLOBAL_GEMINI_DIR/commands"

    echo "Global configuration installed successfully."
}

set_permissions() {
    echo "Setting permissions..."
    chmod +x "$REPO_ROOT/scripts/"*.sh 2>/dev/null || true
    if [ -d "$USER_CONFIG_SRC/hooks" ]; then
        chmod +x "$USER_CONFIG_SRC/hooks/"*.sh 2>/dev/null || true
        chmod +x "$USER_CONFIG_SRC/hooks/"*.js 2>/dev/null || true
        echo "   Hook scripts made executable."
    fi
}

print_summary() {
    echo ""
    echo "========================================================"
    echo "Setup Complete"
    echo "========================================================"
    echo ""
    echo "Active Configuration (v1.2):"
    echo "   - Session Plan: .gemini/SESSION_PLAN.json"
    echo "   - Hooks:        ~/.gemini/hooks/"
    echo "   - Policies:     ~/.gemini/policies/"
    echo "   - Commands:     /refactor, /analyze, /qa, /mcp"
    echo ""
    echo "How to Start:"
    echo "   1. Run 'gemini' in your terminal."
    echo "   2. Type '/refactor <topic>' to start a task."
    echo "   3. Type '/mcp' to check tool connections."
    echo ""
    echo "Tip: Enable sandboxing for safety: export GEMINI_SANDBOX=docker"
    echo ""
}

print_header
check_dependencies
initialize_local_session
install_global_config
set_permissions
print_summary