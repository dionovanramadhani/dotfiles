#!/usr/bin/env bash
export DISPLAY=:0

WALLPAPER_DIR="/home/dionovan/Pictures/wallpaper-all"
selected_theme="Catppuccin"

# Find images and format for rofi
MENU_LIST=""
find "$WALLPAPER_DIR/$selected_theme" -type f -regextype posix-extended -iregex '.*\.(png|jpg|jpeg|webp|bmp)' | sort | while read -r filepath; do
    if [ -n "$filepath" ]; then
        relpath="${filepath#$WALLPAPER_DIR/$selected_theme/}"
        printf "%s\0icon\x1f%s\n" "$relpath" "$filepath"
    fi
done | rofi -dmenu -i -format s -p "Wallpaper" \
    -theme-str '
        window {
            width: 800px;
            height: 450px;
            border: 0px;
            border-radius: 0px;
            padding: 20px;
            background-color: #282828;
            children: [ mainbox ];
        }
        mainbox {
            orientation: horizontal;
            spacing: 20px;
            background-color: transparent;
            children: [ listview, preview-box ];
        }
        listview {
            width: 350px;
            spacing: 4px;
            scrollbar: false;
            border: 0px;
            background-color: transparent;
        }
        preview-box {
            width: 410px;
            background-color: transparent;
            children: [ icon-current-entry ];
        }
        icon-current-entry {
            size: 380px;
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
            background-color: #8ec07c;
            text-color: #282828;
        }
        element-icon {
            enabled: false;
        }
        element-text {
            vertical-align: 0.5;
            text-color: inherit;
            background-color: transparent;
        }
    ' &
ROFIPID=$!
sleep 1.5
maim /home/dionovan/.gemini/antigravity-cli/brain/54252fb6-f822-4649-80b6-70c42fc9367e/test_rofi_preview.png
kill $ROFIPID
pkill -f rofi
