#!/bin/bash

LOG_FILE="$HOME/.cache/notification_history.json"

if [ ! -f "$LOG_FILE" ]; then
    echo "No notifications" | rofi -dmenu -p "Notifications" -theme-str "window { location: southeast; anchor: southeast; x-offset: -10%; y-offset: -48px; width: 450px; }"
    exit 0
fi

# Load notifications, reverse them (newest first), and format for Rofi
# We use index formatting so we can mark the selected item as read
NOTIFICATIONS=$(python3 -c "
import json, os, sys
try:
    with open('$LOG_FILE') as f:
        history = json.load(f)
    for i, n in enumerate(reversed(history)):
        import datetime
        dt = datetime.datetime.fromtimestamp(n['timestamp']).strftime('%H:%M')
        prefix = '● ' if n.get('unread', True) else '  '
        # Trim title and body to keep line clean
        summary = n['summary'][:40]
        body = n['body'][:60]
        print(f\"{prefix}[{dt}] {n['app_name']}: {summary} - {body}\")
except Exception as e:
    pass
")

if [ -z "$NOTIFICATIONS" ]; then
    echo "No notifications" | rofi -dmenu -p "Notifications" -theme-str "window { location: southeast; anchor: southeast; x-offset: -10%; y-offset: -48px; width: 450px; }"
    exit 0
fi

# Show rofi menu
choice_index=$(printf "$NOTIFICATIONS" | rofi -dmenu -i -format i -p "Notifications" -theme-str "window { location: southeast; anchor: southeast; x-offset: -10%; y-offset: -48px; width: 450px; }")

if [ -n "$choice_index" ]; then
    # We selected an item!
    # Convert reversed index back to actual index in history
    # The selected index is 'choice_index' (0-based) from the reversed list
    # So the actual index is: len(history) - 1 - choice_index
    python3 -c "
import json, sys
try:
    with open('$LOG_FILE') as f:
        history = json.load(f)
    
    idx = len(history) - 1 - $choice_index
    if 0 <= idx < len(history):
        # Toggle or mark as read
        history[idx]['unread'] = False
        with open('$LOG_FILE', 'w') as f:
            json.dump(history, f, indent=2)
except Exception as e:
    pass
"
fi
