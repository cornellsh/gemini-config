#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USER_CONFIG_SRC="$REPO_ROOT/user-config"
GLOBAL_GEMINI_DIR="$HOME/.gemini"
LOCAL_GEMINI_DIR="$REPO_ROOT/.gemini"
GLOBAL_BIN_DIR="$HOME/.local/bin"

echo "Structured Gemini Configuration Setup (v1.2.5)"
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
    printf "Install configuration and scripts globally? [y/N] "
    read -r choice
    echo ""

    case "$choice" in 
        [yY][eE][sS]|[yY]) 
            echo "Proceeding with global installation..."
            ;;
        *)
            echo "Skipping global installation."
            return
            ;;
    esac

    mkdir -p "$GLOBAL_GEMINI_DIR"
    mkdir -p "$GLOBAL_BIN_DIR"

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

    # Robust directory syncing: remove destination and recreate symlinks to match source exactly
    sync_dir() {
        local src_dir="$1"
        local dest_dir="$2"
        echo "   Syncing $(basename "$dest_dir")..."
        
        # Remove old directory or symlink if it exists to purge deleted items
        if [ -d "$dest_dir" ] || [ -L "$dest_dir" ]; then
            rm -rf "$dest_dir"
        fi
        mkdir -p "$dest_dir"

        for item in "$src_dir"/*; do
            [ -e "$item" ] || continue
            local item_name=$(basename "$item")
            ln -sf "$item" "$dest_dir/$item_name"
        done
    }

    symlink_file "$USER_CONFIG_SRC/settings.json" "$GLOBAL_GEMINI_DIR/settings.json"
    
    sync_dir "$USER_CONFIG_SRC/skills" "$GLOBAL_GEMINI_DIR/skills"
    sync_dir "$USER_CONFIG_SRC/hooks" "$GLOBAL_GEMINI_DIR/hooks"
    sync_dir "$USER_CONFIG_SRC/policies" "$GLOBAL_GEMINI_DIR/policies"
    sync_dir "$USER_CONFIG_SRC/commands" "$GLOBAL_GEMINI_DIR/commands"

    # Context handled separately as it's often a single target
    rm -rf "$GLOBAL_GEMINI_DIR/context"
    ln -sf "$USER_CONFIG_SRC/context" "$GLOBAL_GEMINI_DIR/context"

    echo "   Installing global scripts to $GLOBAL_BIN_DIR..."
    ln -sf "$REPO_ROOT/scripts/launch_browser.sh" "$GLOBAL_BIN_DIR/gemini-browser-launch"
}

set_permissions() {
    echo "Setting file permissions..."
    chmod +x "$REPO_ROOT/scripts/"*.sh 2>/dev/null || true
    find "$USER_CONFIG_SRC/skills" -name "*.sh" -exec chmod +x {} \;
}

check_dependencies
initialize_local_session
install_global_config
set_permissions

echo ""
echo "Setup complete."
echo "Global scripts installed to $GLOBAL_BIN_DIR (Ensure this is in your PATH)."
echo "Start by running 'gemini' in your terminal."
