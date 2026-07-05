#!/usr/bin/env bash

LOCK_FILE="/tmp/bspwm_alt_tab_active"
if [ -f "$LOCK_FILE" ]; then
    rm -f "$LOCK_FILE"
    bspc wm -h on
    
    # Get the final focused window and update history manually
    focused_win=$(bspc query -N -n focused)
    if [ -n "$focused_win" ]; then
        tmp_hist=$(mktemp)
        echo "$focused_win" > "$tmp_hist"
        if [ -f /tmp/bspwm_focus_history ]; then
            grep -v -i -F "$focused_win" /tmp/bspwm_focus_history >> "$tmp_hist" 2>/dev/null
        fi
        mv "$tmp_hist" /tmp/bspwm_focus_history
    fi
    
    # Trigger a focus event to make sure any other subscribers (like border_focus.sh) are in sync
    bspc node focused -f
fi
