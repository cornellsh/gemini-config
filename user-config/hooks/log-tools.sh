#!/usr/bin/env bash
# Simple logging hook for tool execution
# Logs tool usage to stderr (for visibility) and a file (for audit).

LOG_FILE="$HOME/.gemini/tool-audit.log"

# Read input from stdin
input=$(cat)

# Extract tool name using simple grep/sed fallback if jq isn't present
# (But we expect jq or node in a robust setup, here we use simple text processing for portability)
if command -v jq &> /dev/null; then
    tool_name=$(echo "$input" | jq -r '.tool_name // "unknown"')
else
    tool_name="unknown (jq missing)"
fi

# Log to stderr
echo "[Hook] Tool executed: $tool_name" >&2

# Log to file if directory exists
if [ -d "$HOME/.gemini" ]; then
    echo "[$(date)] Tool: $tool_name" >> "$LOG_FILE"
fi

# IMPORTANT: Output valid JSON to stdout to allow continuation
echo "{}"
exit 0
