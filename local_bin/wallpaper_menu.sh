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

while true; do
    # 1. Select Theme/Category
    selected_theme=$(echo "$themes" | rofi -dmenu -p "Choose Theme" -i \
        -theme /home/dionovan/.config/rofi/config.rasi \
        -theme-str 'window { width: 450px; } listview { columns: 1; lines: 8; }')

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
        done | rofi -dmenu -show-icons -i -p "Wallpaper" \
            -theme /home/dionovan/.config/rofi/config.rasi \
            -theme-str '
                window {
                    width: 1050px;
                    height: 600px;
                    border: 0px;
                    border-radius: 0px;
                    padding: 20px;
                    background-color: @background;
                    children: [ mainbox ];
                }
                mainbox {
                    orientation: horizontal;
                    spacing: 20px;
                    background-color: transparent;
                    children: [ listview, preview-box ];
                }
                listview {
                    width: 400px;
                    spacing: 4px;
                    scrollbar: false;
                    border: 0px;
                    background-color: transparent;
                }
                preview-box {
                    width: 610px;
                    background-color: transparent;
                    children: [ icon-current-entry ];
                }
                icon-current-entry {
                    size: 550px;
                    horizontal-align: 0.5;
                    vertical-align: 0.5;
                    background-color: transparent;
                }
                element {
                    padding: 8px 12px;
                    border-radius: 0px;
                    background-color: transparent;
                }
                element selected {
                    background-color: @selected-normal-background;
                    text-color: @selected-normal-foreground;
                }
                element-icon {
                    enabled: false;
                }
                element-text {
                    vertical-align: 0.5;
                    text-color: inherit;
                    background-color: transparent;
                }
            '
    )

    if [ -z "$selected_wallpaper_name" ]; then
        # Back to theme list if Esc is pressed
        continue
    fi

    selected_wallpaper_path="$WALLPAPER_DIR/$selected_theme/$selected_wallpaper_name"

    if [ -f "$selected_wallpaper_path" ]; then
        # Execute the transition script in the background
        /home/dionovan/.local/bin/change_wallpaper.py "$selected_wallpaper_path" &
    else
        rofi -e "Selected wallpaper not found: $selected_wallpaper_path"
    fi
    break
done
