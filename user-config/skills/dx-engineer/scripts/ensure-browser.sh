#!/bin/bash
# Browser Pre-flight Check
# Verifies if Chrome is active and responding to CDP commands.

PORT=9222

if curl -s "http://127.0.0.1:$PORT/json/version" > /dev/null; then
    echo "{\"status\": \"ready\", \"port\": $PORT}"
    exit 0
else
    # Attempt to auto-launch using our robust script
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # Path relative to the skills folder or use absolute from repo root
    LAUNCH_SCRIPT="$GEMINI_PROJECT_DIR/scripts/launch_browser.sh"
    
    if [ -f "$LAUNCH_SCRIPT" ]; then
        echo "Browser not found. Attempting auto-launch..." >&2
        bash "$LAUNCH_SCRIPT" > /dev/null 2>&1
        
        if curl -s "http://127.0.0.1:$PORT/json/version" > /dev/null; then
            echo "{\"status\": \"launched\", \"port\": $PORT}"
            exit 0
        fi
    fi
    
    echo "{\"status\": \"error\", \"message\": \"Chrome not found on port $PORT and auto-launch failed.\"}"
    exit 1
fi
