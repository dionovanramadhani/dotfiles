#!/usr/bin/env bash
# layout.sh — real-time bspwm layout indicator for Polybar

TILED_ICON='󰕰'
MONOCLE_ICON='󰘚'

get_layout() {
    local layout
    layout=$(bspc query -T -d | grep -o '"layout":"[^"]*"' | cut -d'"' -f4)
    if [[ "$layout" == "monocle" ]]; then
        # Monocle: Purple color + icon + text + click to toggle
        echo "%{A1:bspc desktop -l next:}%{F#d3869b}%{T4}${MONOCLE_ICON}%{T-} Monocle%{F-}%{A}"
    else
        # Tiled: Blue color + icon + text + click to toggle
        echo "%{A1:bspc desktop -l next:}%{F#83a598}%{T4}${TILED_ICON}%{T-} Tiled%{F-}%{A}"
    fi
}

# Initial render
get_layout

# Listen to layout changes, desktop focus, and monitor focus
bspc subscribe desktop_layout desktop_focus monitor_focus | while read -r _; do
    get_layout
done
