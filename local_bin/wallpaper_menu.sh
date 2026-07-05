#!/usr/bin/env bash

WALLPAPER_DIR="/home/dionovan/Pictures/wallpaper-all"

# 1. Select Theme/Category
# Get list of subdirectories (Catppuccin, Nord, One Dark, etc.)
if [ ! -d "$WALLPAPER_DIR" ]; then
    rofi -e "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

themes=$(find "$WALLPAPER_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)

if [ -z "$themes" ]; then
    rofi -e "No theme folders found in $WALLPAPER_DIR"
    exit 1
fi

selected_theme=$(echo "$themes" | rofi -dmenu -p "Choose Theme" -i)

if [ -z "$selected_theme" ]; then
    exit 0
fi

# 2. Select Wallpaper
# Find all images recursively inside the selected theme directory
# Generate list with format: DisplayName\0icon\x1fAbsoluteFilePath
selected_wallpaper_name=$(
    find "$WALLPAPER_DIR/$selected_theme" -type f -regextype posix-extended -iregex '.*\.(png|jpg|jpeg|webp|bmp)' | sort | while read -r filepath; do
        if [ -n "$filepath" ]; then
            relpath="${filepath#$WALLPAPER_DIR/$selected_theme/}"
            # Using printf to properly output null byte \0 and separator \x1f
            printf "%s\0icon\x1f%s\n" "$relpath" "$filepath"
        fi
    done | rofi -dmenu -show-icons -p "Choose Wallpaper ($selected_theme)" -i
)

if [ -z "$selected_wallpaper_name" ]; then
    exit 0
fi

selected_wallpaper_path="$WALLPAPER_DIR/$selected_theme/$selected_wallpaper_name"

if [ -f "$selected_wallpaper_path" ]; then
    # Execute the transition script in the background
    /home/dionovan/.local/bin/change_wallpaper.py "$selected_wallpaper_path" &
else
    rofi -e "Selected wallpaper not found: $selected_wallpaper_path"
fi
