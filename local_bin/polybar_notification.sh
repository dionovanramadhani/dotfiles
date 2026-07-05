#!/bin/bash

LOG_FILE="$HOME/.cache/notification_history.json"

if [ ! -f "$LOG_FILE" ]; then
    # Gray bell
    echo "%{F#a89984}%{F-}"
    exit 0
fi

# Count unread notifications using Python
unread_count=$(python3 -c "
import json
try:
    with open('$LOG_FILE') as f:
        history = json.load(f)
    count = sum(1 for n in history if n.get('unread', True))
    print(count)
except Exception:
    print(0)
")

if [ "$unread_count" -gt 0 ]; then
    # Yellow bell with count
    echo "%{F#fabd2f} $unread_count%{F-}"
else
    # Gray bell
    echo "%{F#a89984}%{F-}"
fi
