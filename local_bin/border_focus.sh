#!/usr/bin/env bash

PID_FILE="/tmp/border_focus.pid"

# Terminate other instances of the same script using the PID file
if [ -f "$PID_FILE" ]; then
    old_pid=$(cat "$PID_FILE")
    if [ -n "$old_pid" ] && kill -0 "$old_pid" 2>/dev/null; then
        pkill -P "$old_pid" 2>/dev/null
        kill "$old_pid" 2>/dev/null
        sleep 0.1
        if kill -0 "$old_pid" 2>/dev/null; then
            kill -9 "$old_pid" 2>/dev/null
        fi
    fi
fi
echo "$$" > "$PID_FILE"

# Clean up child processes on exit
trap 'pkill -P $$ 2>/dev/null' EXIT INT TERM HUP

# Initialize: set default border width and hide it on the currently focused window
bspc config border_width 2
bspc config -n focused border_width 0

# Initialize history file with the currently focused window if it exists
focused_win=$(bspc query -N -n focused)
if [ -n "$focused_win" ]; then
    echo "$focused_win" > /tmp/bspwm_focus_history
    bspc node "$focused_win" --layer above 2>/dev/null
fi

# Subscribe to focus events and update border widths dynamically
bspc subscribe node_focus | while read -r _ _ _ node_id; do
    # Get previously focused window from history
    prev_win=$(head -n 1 /tmp/bspwm_focus_history 2>/dev/null)

    # Reset layer and border of the last focused window
    if [ -n "$prev_win" ] && [ "$prev_win" != "$node_id" ]; then
        bspc node "$prev_win" --layer normal 2>/dev/null
        bspc config -n "$prev_win" border_width 2 2>/dev/null
    fi

    # Set layer and remove border of the currently focused window
    bspc node "$node_id" --layer above 2>/dev/null
    bspc config -n "$node_id" border_width 0 2>/dev/null
    
    # Update focus history file only if Alt+Tab is not active
    if [ ! -f /tmp/bspwm_alt_tab_active ] && [ -n "$node_id" ]; then
        tmp_hist=$(mktemp)
        echo "$node_id" > "$tmp_hist"
        if [ -f /tmp/bspwm_focus_history ]; then
            grep -v -i -F "$node_id" /tmp/bspwm_focus_history >> "$tmp_hist" 2>/dev/null
        fi
        mv "$tmp_hist" /tmp/bspwm_focus_history
    fi
done
