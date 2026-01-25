#!/bin/bash
# Browser Pre-flight Check
# Verifies if Chrome is active and responding to CDP commands.

PORT=9222

if curl -s "http://127.0.0.1:$PORT/json/version" > /dev/null; then
    echo "{\"status\": \"ready\", \"port\": $PORT}"
    exit 0
else
    # Attempt to auto-launch using global command or repo-relative script
    if command -v gemini-browser-launch &> /dev/null; then
        echo "Browser not found. Attempting auto-launch via global command..." >&2
        gemini-browser-launch > /dev/null 2>&1
    elif [ -f "$GEMINI_PROJECT_DIR/scripts/launch_browser.sh" ]; then
        echo "Browser not found. Attempting auto-launch via local script..." >&2
        bash "$GEMINI_PROJECT_DIR/scripts/launch_browser.sh" > /dev/null 2>&1
    else
        echo "{\"status\": \"error\", \"message\": \"Chrome launcher not found.\"}"
        exit 1
    fi
    
    # Verify launch success
    if curl -s "http://127.0.0.1:$PORT/json/version" > /dev/null; then
        echo "{\"status\": \"launched\", \"port\": $PORT}"
        exit 0
    fi
    
    echo "{\"status\": \"error\", \"message\": \"Chrome not found on port $PORT and auto-launch failed.\"}"
    exit 1
fi