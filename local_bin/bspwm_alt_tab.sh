#!/usr/bin/env bash

LOCK_FILE="/tmp/bspwm_alt_tab_active"
LIST_FILE="/tmp/bspwm_alt_tab_list"
INDEX_FILE="/tmp/bspwm_alt_tab_index"

# 1. If this is the start of Alt+Tab cycle, freeze the window list
if [ ! -f "$LOCK_FILE" ]; then
    touch "$LOCK_FILE"
    bspc wm -h off
    
    # Get all windows on current desktop
    local_wins=$(bspc query -N -d -n .window.!hidden)
    
    # Order them by history
    ordered_wins=""
    if [ -f /tmp/bspwm_focus_history ]; then
        while read -r win_id; do
            # Check if this window exists on the current desktop and is not hidden
            if echo "$local_wins" | grep -q -i -F "$win_id"; then
                ordered_wins="$ordered_wins $win_id"
            fi
        done < /tmp/bspwm_focus_history
    fi
    
    # Append any local windows that are not in history
    for win_id in $local_wins; do
        if ! echo "$ordered_wins" | grep -q -i -F "$win_id"; then
            ordered_wins="$ordered_wins $win_id"
        fi
    done
    
    # Clean up spaces and save to file
    echo "$ordered_wins" | tr -s ' ' '\n' | grep -v '^$' > "$LIST_FILE"
    
    # Set index to 0 (which is the currently focused window)
    echo "0" > "$INDEX_FILE"
fi

# 2. Cycle to the next window in the list
if [ -s "$LIST_FILE" ]; then
    wins=($(cat "$LIST_FILE"))
    num_wins=${#wins[@]}
    
    if [ "$num_wins" -gt 1 ]; then
        idx=$(cat "$INDEX_FILE")
        # Calculate next index
        next_idx=$(( (idx + 1) % num_wins ))
        echo "$next_idx" > "$INDEX_FILE"
        
        target_win="${wins[$next_idx]}"
        bspc node "$target_win" -f
    fi
fi
