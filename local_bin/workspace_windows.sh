#!/bin/bash

# Get all windows on the current desktop
WINDOWS=$(bspc query -N -d focused -n .window)

if [ -z "$WINDOWS" ]; then
    exit 0
fi

# Run the loop to format display names and pipe to rofi, returning only the selected index (0-based)
choice_index=$(
    for id in $WINDOWS; do
        # Get window name (title)
        name=$(xdotool getwindowname "$id" 2>/dev/null)
        
        # Trim leading/trailing whitespace
        trimmed_name=$(echo "$name" | xargs)
        
        # If name is empty or only whitespace, fallback to class name
        if [ -z "$trimmed_name" ]; then
            name=$(xprop -id "$id" WM_CLASS 2>/dev/null | cut -d '"' -f 4)
        else
            name="$trimmed_name"
        fi
        
        if [ -z "$name" ]; then
            name="Window $id"
        fi

        # Get instance and class name for the icon
        wm_class=$(xprop -id "$id" WM_CLASS 2>/dev/null)
        instance=$(echo "$wm_class" | cut -d '"' -f 2)
        class=$(echo "$wm_class" | cut -d '"' -f 4)

        # Normalize names to lowercase for robust matching
        inst_lower=$(echo "$instance" | tr '[:upper:]' '[:lower:]')
        class_lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')

        # Special title logic for Neovide to show the directory
        if [[ "$inst_lower" == *"neovide"* ]]; then
            pid=$(xdotool getwindowpid "$id" 2>/dev/null)
            cwd=""
            if [ -n "$pid" ]; then
                # Try to get CWD of the child nvim process first (supports :cd inside Neovim)
                nvim_pid=$(pgrep -P "$pid" -x nvim 2>/dev/null | head -n 1)
                if [ -n "$nvim_pid" ]; then
                    cwd=$(readlink -f "/proc/$nvim_pid/cwd" 2>/dev/null)
                fi
                # Fallback to Neovide parent process CWD
                if [ -z "$cwd" ]; then
                    cwd=$(readlink -f "/proc/$pid/cwd" 2>/dev/null)
                fi
            fi
            
            if [ -n "$cwd" ]; then
                # Replace home directory with ~
                cwd_display=${cwd/#$HOME/\~}
                name="neovide - $cwd_display"
            else
                name="neovide"
            fi
        fi

        # Map to correct icon name in the theme
        if [[ "$inst_lower" == *"whatsapp"* ]]; then
            icon_name="whatsapp"
        elif [[ "$inst_lower" == *"alacritty"* ]]; then
            icon_name="Alacritty"
        elif [[ "$inst_lower" == *"telegram"* ]]; then
            icon_name="telegram"
        elif [[ "$inst_lower" == *"neovide"* ]]; then
            icon_name="nvim"
        elif [[ "$inst_lower" == *"antigravity"* ]]; then
            icon_name="/usr/share/pixmaps/antigravity.png"
        elif [[ "$inst_lower" == *"spotify"* ]]; then
            icon_name="spotify"
        elif [[ "$inst_lower" == *"helium"* ]]; then
            icon_name="helium"
        else
            icon_name="$class_lower"
            if [ -z "$icon_name" ]; then
                icon_name="$inst_lower"
            fi
        fi

        # Check if window is hidden
        prefix=""
        if bspc query -N -n "$id.hidden" >/dev/null; then
            prefix="[Hidden] "
        fi

        # Format: Display Name\0icon\037IconName
        printf "%s\0icon\037%s\n" "$prefix$name" "$icon_name"
    done | rofi -dmenu -i -format i -show-icons -p "Windows"
)

# Check if a choice was made (index is a number)
if [ -n "$choice_index" ]; then
    # Convert 0-based index to 1-based for sed
    line_num=$((choice_index + 1))
    
    # Get the window ID corresponding to the selected index
    win_id=$(echo "$WINDOWS" | sed -n "${line_num}p")

    if [ -n "$win_id" ]; then
        # If the window is hidden, unhide it
        if bspc query -N -n "$win_id.hidden" >/dev/null; then
            bspc node "$win_id" -g hidden=off
        fi
        # Focus the window
        bspc node "$win_id" -f
    fi
fi
