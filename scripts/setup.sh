#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USER_CONFIG_SRC="$REPO_ROOT/user-config"
GLOBAL_GEMINI_DIR="$HOME/.gemini"
LOCAL_GEMINI_DIR="$REPO_ROOT/.gemini"

echo "Structured Gemini Configuration Setup (v1.2.2)"
echo ""

check_dependencies() {
    echo "Checking dependencies..."
    
    if ! command -v node &> /dev/null; then
        echo "Error: Node.js not found. Node.js is required."
        exit 1
    fi

    if ! command -v gemini &> /dev/null; then
        echo "Warning: 'gemini' CLI not found in PATH."
    fi

    if ! command -v rg &> /dev/null; then
        echo "Warning: 'rg' (ripgrep) not found."
    fi
}

initialize_local_session() {
    echo "Initializing local session state..."
    mkdir -p "$LOCAL_GEMINI_DIR"

    if [ ! -f "$LOCAL_GEMINI_DIR/SESSION_PLAN.json" ]; then
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
    fi

    if [ ! -f "$LOCAL_GEMINI_DIR/SESSION_PLAN.md" ]; then
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
    fi
}

install_global_config() {
    echo ""
    read -p "Install configuration globally to $GLOBAL_GEMINI_DIR? [y/N] " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi

    echo "Installing global configuration..."
    mkdir -p "$GLOBAL_GEMINI_DIR"/{skills,context,hooks,policies,commands}

    symlink_file() {
        local src="$1"
        local dest="$2"
        if [ -f "$dest" ] || [ -L "$dest" ]; then
            if [ "$(readlink "$dest")" != "$src" ]; then
                mv "$dest" "$dest.$(date +%Y%m%d_%H%M%S).bak"
                ln -sf "$src" "$dest"
            fi
        else
            ln -sf "$src" "$dest"
        fi
    }

    symlink_dir_contents() {
        local src_dir="$1"
        local dest_dir="$2"
        mkdir -p "$dest_dir"
        for item in "$src_dir"/*; do
            [ -e "$item" ] || continue
            local item_name=$(basename "$item")
            rm -rf "$dest_dir/$item_name"
            ln -sf "$item" "$dest_dir/$item_name"
        done
    }

    symlink_file "$USER_CONFIG_SRC/settings.json" "$GLOBAL_GEMINI_DIR/settings.json"
    symlink_dir_contents "$USER_CONFIG_SRC/skills" "$GLOBAL_GEMINI_DIR/skills"
    rm -rf "$GLOBAL_GEMINI_DIR/context"
    ln -sf "$USER_CONFIG_SRC/context" "$GLOBAL_GEMINI_DIR/context"
    symlink_dir_contents "$USER_CONFIG_SRC/hooks" "$GLOBAL_GEMINI_DIR/hooks"
    symlink_dir_contents "$USER_CONFIG_SRC/policies" "$GLOBAL_GEMINI_DIR/policies"
    symlink_dir_contents "$USER_CONFIG_SRC/commands" "$GLOBAL_GEMINI_DIR/commands"
}

set_permissions() {
    echo "Setting file permissions..."
    chmod +x "$REPO_ROOT/scripts/"*.sh 2>/dev/null || true
    
    # Secure all skill-based internal tools
    find "$USER_CONFIG_SRC/skills" -name "*.sh" -exec chmod +x {} \;
    find "$USER_CONFIG_SRC/skills" -name "*.js" -exec chmod +x {} \;
}

check_dependencies
initialize_local_session
install_global_config
set_permissions

echo ""
echo "Setup complete."
echo "Configured for: /refactor, /analyze, /qa, /mcp"
echo ""
echo "Recommended: Enable browser debugging:"
echo "1. gemini extensions install https://github.com/ChromeDevTools/chrome-devtools-mcp"
echo "2. run scripts/launch_browser.sh"
echo ""
echo "Start by running 'gemini' in your terminal."