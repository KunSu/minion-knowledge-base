#!/bin/bash
# Keeps Mac awake using macOS-native caffeinate.
# Prevents system idle sleep, display sleep, and disk idle sleep — on AC or battery.
# Usage:
#   awake 2         # Keep awake for 2 hours
#   awake --disable # Stop keeping awake

PID_FILE="/tmp/keep_awake.pid"

if [ "$1" = "--disable" ]; then
    if [ -f "$PID_FILE" ]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null
        rm -f "$PID_FILE"
        echo "Keep-awake disabled."
    else
        echo "No keep-awake process running."
    fi
    exit 0
fi

HOURS="${1:-1}"
if ! [[ "$HOURS" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Usage: awake <hours> | awake --disable"
    exit 1
fi

# Kill existing process if running
if [ -f "$PID_FILE" ]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null
    rm -f "$PID_FILE"
fi

SECONDS_TO_RUN=$(printf "%.0f" "$(echo "$HOURS * 3600" | bc)")

# -d prevent display sleep  -i prevent system idle sleep  -m prevent disk idle sleep
# -u declare user activity  -t run for N seconds
# (no -s: -s only works on AC; -dim covers battery too)
# Run caffeinate in the background but WAIT on it, so this script stays alive
# for the whole duration. PID_FILE holds caffeinate's pid so --disable can stop it.
caffeinate -dimu -t "$SECONDS_TO_RUN" &
CAFF_PID=$!
echo "$CAFF_PID" > "$PID_FILE"
echo "Keeping Mac awake for $HOURS hour(s) via caffeinate. PID: $CAFF_PID"
wait "$CAFF_PID"
rm -f "$PID_FILE"
echo "Keep-awake finished."
