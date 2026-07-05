#!/usr/bin/env bash

# Terminate other instances of the same script
for pid in $(pgrep -f "$(basename "$0")"); do
    if [ "$pid" != "$$" ]; then
        kill "$pid" 2>/dev/null
    fi
done

# Initialize: set default border width and hide it on the currently focused window
bspc config border_width 2
bspc config -n focused border_width 0

# Initialize history file with the currently focused window if it exists
focused_win=$(bspc query -N -n focused)
if [ -n "$focused_win" ]; then
    echo "$focused_win" > /tmp/bspwm_focus_history
fi

# Subscribe to focus events and update border widths dynamically
bspc subscribe node_focus | while read -r _ _ _ node_id; do
    # Reset border of the last focused window to default
    bspc config -n last border_width 2 2>/dev/null
    # Remove border of the currently focused window
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
