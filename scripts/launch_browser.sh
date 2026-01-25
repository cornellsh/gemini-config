#!/bin/bash

# Configuration
PORT=9222
CHROME_BIN=$(which google-chrome || which google-chrome-stable || which chromium || which chromium-browser)

if [ -z "$CHROME_BIN" ]; then
    echo "Error: Chrome/Chromium binary not found." >&2
    exit 1
fi

echo "Using Chrome binary: $CHROME_BIN" >&2

# Cleanup existing Chrome processes on the target port
echo "Cleaning up existing processes on port $PORT..." >&2
fuser -k $PORT/tcp 2>/dev/null || true

# Start Chrome with robust automation flags
# --headless=new is the modern headless mode
# --disable-dev-shm-usage prevents crashes in container/constrained envs
# --remote-debugging-address=127.0.0.1 for security
echo "Starting Chrome on port $PORT..." >&2
nohup "$CHROME_BIN" \
    --headless=new \
    --remote-debugging-port=$PORT \
    --remote-debugging-address=127.0.0.1 \
    --disable-gpu \
    --no-sandbox \
    --disable-setuid-sandbox \
    --disable-dev-shm-usage \
    --remote-allow-origins="*" \
    --user-data-dir="/tmp/chrome-remote-profile-$(date +%s)" \
    > /tmp/chrome_headless.log 2>&1 &

# Wait for Chrome to initialize and verify the JSON API
echo "Waiting for Chrome to initialize..." >&2
MAX_RETRIES=15
COUNT=0
while ! curl -s "http://127.0.0.1:$PORT/json/version" > /dev/null; do
    sleep 1
    COUNT=$((COUNT+1))
    if [ $COUNT -ge $MAX_RETRIES ]; then
        echo "Error: Chrome failed to start after $MAX_RETRIES seconds." >&2
        tail -n 20 /tmp/chrome_headless.log >&2
        exit 1
    fi
done

echo "Chrome is ready and responding at http://127.0.0.1:$PORT" >&2
curl -s "http://127.0.0.1:$PORT/json/version"
