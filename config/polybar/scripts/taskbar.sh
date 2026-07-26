#!/usr/bin/env bash
# taskbar.sh — displays a list of open windows in the current workspace

MONITOR="$1"

if [[ "$1" == "focus" || "$1" == "hide" || "$1" == "unhide" ]]; then
    action="$1"
    win_id="$2"
    case "$action" in
        focus)
            bspc config pointer_follows_focus false
            bspc node -f "$win_id"
            bspc config pointer_follows_focus true
            ;;
        hide)
            bspc config pointer_follows_focus false
            bspc node "$win_id" -g hidden=on
            bspc config pointer_follows_focus true
            ;;
        unhide)
            bspc config pointer_follows_focus false
            bspc node "$win_id" -g hidden=off -f
            bspc config pointer_follows_focus true
            ;;
    esac
    exit 0
fi

# Font icons (using Nerd Font)
ICON_TERMINAL='󰞷'
ICON_BROWSER='󰖟'
ICON_SPOTIFY='󰓇'
ICON_DISCORD='󰙯'
ICON_WHATSAPP='󰖣'
ICON_FILES='󰉋'
ICON_NEOVIM=''
ICON_CODE='󰨞'
ICON_GENERIC='󰖲'

get_window_icon() {
    local win_id=$1
    local wm_class
    wm_class=$(xprop -id "$win_id" WM_CLASS 2>/dev/null)
    local class
    class=$(echo "$wm_class" | cut -d '"' -f 4 | tr '[:upper:]' '[:lower:]')
    local instance
    instance=$(echo "$wm_class" | cut -d '"' -f 2 | tr '[:upper:]' '[:lower:]')

    if [[ "$class" == *"alacritty"* || "$instance" == *"alacritty"* ]]; then
        echo "$ICON_TERMINAL"
    elif [[ "$class" == *"firefox"* || "$class" == *"chrome"* || "$class" == *"brave"* || "$class" == *"helium"* || "$instance" == *"helium"* ]]; then
        echo "$ICON_BROWSER"
    elif [[ "$class" == *"spotify"* || "$instance" == *"spotify"* ]]; then
        echo "$ICON_SPOTIFY"
    elif [[ "$class" == *"discord"* || "$instance" == *"discord"* ]]; then
        echo "$ICON_DISCORD"
    elif [[ "$class" == *"whatsapp"* || "$instance" == *"whatsapp"* ]]; then
        echo "$ICON_WHATSAPP"
    elif [[ "$class" == *"thunar"* || "$instance" == *"thunar"* ]]; then
        echo "$ICON_FILES"
    elif [[ "$class" == *"neovide"* || "$instance" == *"neovide"* || "$class" == *"nvim"* ]]; then
        echo "$ICON_NEOVIM"
    elif [[ "$class" == *"code"* || "$instance" == *"code"* ]]; then
        echo "$ICON_CODE"
    else
        echo "$ICON_GENERIC"
    fi
}

get_window_title() {
    local win_id=$1
    local name
    name=$(xdotool getwindowname "$win_id" 2>/dev/null)
    name=$(echo "$name" | xargs)
    if [ -z "$name" ]; then
        name=$(xprop -id "$win_id" WM_CLASS 2>/dev/null | cut -d '"' -f 4)
    fi
    if [ -z "$name" ]; then
        name="Window"
    fi
    
    # Truncate title to keep taskbar neat
    if [ ${#name} -gt 15 ]; then
        echo "${name:0:12}..."
    else
        echo "$name"
    fi
}

render() {
    local target_mon="${MONITOR:-focused}"
    local windows
    windows=$(bspc query -N -d "${target_mon}:focused" -n .window)
    local focused_win
    focused_win=$(bspc query -N -d "${target_mon}:focused" -n .window.focused)
    
    # Use non-breaking space (U+00A0) to prevent Polybar from stripping whitespace
    # and ensure the background color block covers the padding area around the icon.
    local NBSP=$'\u00a0'
    
    # Use a negative offset to pull the taskbar closer to the divider on the left
    local out="%{O-10}"
    for win_id in $windows; do
        local icon
        icon=$(get_window_icon "$win_id")
        local title
        title=$(get_window_title "$win_id")
        
        # Check if window is hidden
        local is_hidden=false
        if bspc query -N -n "$win_id.hidden" >/dev/null; then
            is_hidden=true
        fi
        
        # Format the item using non-breaking spaces for padding
        if [ "$win_id" = "$focused_win" ]; then
            # Focused window: Yellow text, bold, background-alt highlight, padded. Click to hide.
            out+="%{A1:bash ~/.config/polybar/scripts/taskbar.sh hide $win_id:}%{F#fabd2f}%{B#3c3836}${NBSP}${NBSP}%{T4}${icon}%{T-}${NBSP}${title}${NBSP}${NBSP}%{B-}%{F-}%{A}"
        elif [ "$is_hidden" = true ]; then
            # Hidden window: Green text (Gruvbox green #b8bb26), click action to unhide and focus
            out+="%{A1:bash ~/.config/polybar/scripts/taskbar.sh unhide $win_id:}%{F#b8bb26}${NBSP}${NBSP}%{T4}${icon}%{T-}${NBSP}${title}${NBSP}${NBSP}%{F-}%{A}"
        else
            # Unfocused window: standard foreground
            out+="%{A1:bash ~/.config/polybar/scripts/taskbar.sh focus $win_id:}%{F#fbf1c7}${NBSP}${NBSP}%{T4}${icon}%{T-}${NBSP}${title}${NBSP}${NBSP}%{F-}%{A}"
        fi
        out+="%{O6}" # Small offset/spacing between taskbar items
    done
    
    echo "$out"
}

# Initial render
render

# Listen for updates from bspwm
bspc subscribe desktop node | while read -r _; do
    render
done
