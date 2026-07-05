#!/bin/bash

# Get the current default sink
DEFAULT_SINK=$(pactl get-default-sink)

# Get the list of all sinks
SINKS=$(pactl list sinks | awk '/^Sink #/ {id=$2} /^[[:space:]]*Name:/ {name=$2} /^[[:space:]]*Description:/ {desc=substr($0, index($0, $2)); print name " | " desc}')

if [ -z "$SINKS" ]; then
    exit 0
fi

# Build Rofi list
MENU_LIST=""
while IFS= read -r line; do
    name=$(echo "$line" | cut -d '|' -f 1 | xargs)
    desc=$(echo "$line" | cut -d '|' -f 2- | xargs)
    
    prefix="   "
    if [ "$name" = "$DEFAULT_SINK" ]; then
        prefix="●  "
    fi
    
    MENU_LIST="$MENU_LIST\n$prefix$desc"
done <<< "$SINKS"

# Show rofi menu
choice_index=$(printf "$MENU_LIST" | sed '/^$/d' | rofi -dmenu -i -format i -p "Audio Output")

if [ -n "$choice_index" ]; then
    line_num=$((choice_index + 1))
    
    # Get the target sink name corresponding to the selected index
    selected_sink=$(echo "$SINKS" | sed -n "${line_num}p" | cut -d '|' -f 1 | xargs)
    selected_desc=$(echo "$SINKS" | sed -n "${line_num}p" | cut -d '|' -f 2- | xargs)
    
    if [ -n "$selected_sink" ]; then
        pactl set-default-sink "$selected_sink"
        
        # Notify the user
        notify-send -t 2000 -i audio-speakers "Audio Output Changed" "Default output set to:\n$selected_desc"
    fi
fi
