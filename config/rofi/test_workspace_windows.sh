#!/usr/bin/env bash
export DISPLAY=:0

# Run workspace_windows.sh but redirect to our test rofi call
WINDOWS=$(bspc query -N -d focused -n .window)
if [ -z "$WINDOWS" ]; then
    # Open a few terminals temporarily so we have windows to show!
    alacritty --class test_term1 -e sleep 10 &
    alacritty --class test_term2 -e sleep 10 &
    sleep 0.5
    WINDOWS=$(bspc query -N -d focused -n .window)
fi

# Build list
MENU_LIST=""
for id in $WINDOWS; do
    wm_class=$(xprop -id "$id" WM_CLASS 2>/dev/null)
    class=$(echo "$wm_class" | cut -d '"' -f 4)
    class_lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')
    printf "Window\0icon\037%s\n" "$class_lower"
done | rofi -dmenu -i -format i \
    -theme ~/.config/rofi/config.rasi \
    -theme-str '
        window {
            width: 400px;
            border: 0px;
            border-radius: 0px;
            padding: 15px;
            background-color: #282828;
            children: [ listview ];
        }
        listview {
            layout: horizontal;
            spacing: 12px;
            border: 0px;
            background-color: transparent;
        }
        element {
            padding: 8px;
            border-radius: 0px;
            background-color: transparent;
        }
        element selected {
            background-color: #8ec07c;
        }
        element-icon {
            size: 36px;
            horizontal-align: 0.5;
            vertical-align: 0.5;
        }
        element-text {
            enabled: false;
        }
    ' -p "Windows" &
ROFIPID=$!
sleep 1.0
maim /home/dionovan/.gemini/antigravity-cli/brain/54252fb6-f822-4649-80b6-70c42fc9367e/test_workspace_windows.png
kill $ROFIPID
pkill -f rofi
pkill -f test_term1
pkill -f test_term2
