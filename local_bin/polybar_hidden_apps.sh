#!/bin/bash

# Query all hidden windows on the focused desktop
WINDOWS=$(bspc query -N -d focused -n .hidden)

if [ -z "$WINDOWS" ]; then
    echo ""
    exit 0
fi

ICONS=""
for id in $WINDOWS; do
    # Get instance and class names
    wm_class=$(xprop -id "$id" WM_CLASS 2>/dev/null)
    instance=$(echo "$wm_class" | cut -d '"' -f 2)
    class=$(echo "$wm_class" | cut -d '"' -f 4)

    # Normalize to lowercase
    inst_lower=$(echo "$instance" | tr '[:upper:]' '[:lower:]')
    class_lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')

    # Map to Nerd Font icon, official brand color, and clean real-world app name
    icon=""
    color=""
    app_name=""
    case "$inst_lower" in
        *spotify*)
            icon="" # Spotify
            color="#1DB954" # Spotify Green
            app_name="spotify"
            ;;
        *alacritty*)
            icon="" # Terminal
            color="#ebdbb2" # Alacritty/Gruvbox light foreground
            app_name="alacritty"
            ;;
        *telegram*)
            icon="" # Telegram
            color="#0088cc" # Telegram Blue
            app_name="telegram"
            ;;
        *neovide*)
            icon="" # Neovim icon
            color="#57A143" # Neovim Green
            app_name="neovide"
            ;;
        *antigravity*)
            icon="" # IDE icon
            color="#57A143" # Green
            app_name="antigravity"
            ;;
        *whatsapp*)
            icon="" # WhatsApp
            color="#25D366" # WhatsApp Green
            app_name="whatsapp"
            ;;
        *helium*)
            title=$(xdotool getwindowname "$id" 2>/dev/null | tr '[:upper:]' '[:lower:]')
            if [[ "$title" == *"whatsapp"* ]]; then
                icon=""
                color="#25D366"
                app_name="whatsapp"
            else
                icon="" # Web Browser
                color="#8ec07c" # Gruvbox Cyan/Aqua
                app_name="helium"
            fi
            ;;
        *discord*)
            icon="" # Discord
            color="#5865F2" # Discord Blurple
            app_name="discord"
            ;;
        *thunar*)
            icon="" # File manager
            color="#fe8019" # Gruvbox Orange
            app_name="thunar"
            ;;
        *chrome*|*chromium*|*firefox*)
            icon="" # Browser
            color="#4285F4" # Chrome Blue
            app_name="browser"
            ;;
        *code*|*vscode*)
            icon="" # VS Code
            color="#007acc" # VS Code Blue
            app_name="vscode"
            ;;
        *)
            # Fallback to class/instance
            icon=""
            color="#a89984"
            if [ -n "$inst_lower" ]; then
                app_name="$inst_lower"
            else
                app_name="app"
            fi
            ;;
    esac

    # Append the icon (T5 = size 14) and app name (T3 = size 10, muted gray) wrapped in an action tag
    ICONS="$ICONS%{A1:/home/dionovan/.local/bin/restore_hidden_window.sh $id:}%{F$color}%{T5}$icon%{T-}%{F-} %{F#a89984}%{T3}$app_name%{T-}%{F-}%{A} "
done

# Print the icons with spaces preserved
echo "$ICONS"
