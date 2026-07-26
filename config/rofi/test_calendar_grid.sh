#!/usr/bin/env bash
export DISPLAY=:0

TODAY=$(date +%-d)
CURRENT_MONTH=$(date +%-m)
CURRENT_YEAR=$(date +%Y)
YEAR=$CURRENT_YEAR
MONTH=$CURRENT_MONTH

zpad() { printf "%02d" "$1"; }

generate_calendar() {
    local year=$1 month=$2
    local zm; zm=$(zpad "$month")
    local month_name; month_name=$(date -d "${year}-${zm}-01" +"%B %Y")
    local pm py nm ny
    if [[ $month -eq 1  ]]; then pm=12; py=$((year-1)); else pm=$((month-1)); py=$year; fi
    if [[ $month -eq 12 ]]; then nm=1;  ny=$((year+1)); else nm=$((month+1)); ny=$year; fi
    local pname nname
    pname=$(date -d "${py}-$(zpad $pm)-01" +"%B %Y")
    nname=$(date -d "${ny}-$(zpad $nm)-01" +"%B %Y")

    local fdow ndim
    fdow=$(date -d "${year}-${zm}-01" +%w)
    ndim=$(date -d "${year}-${zm}-01 +1 month -1 day" +%d)

    # Weekday headers
    echo "Su"
    echo "Mo"
    echo "Tu"
    echo "We"
    echo "Th"
    echo "Fr"
    echo "Sa"

    # Offset
    for ((i=0; i<fdow; i++)); do
        echo " "
    done

    # Days
    for ((d=1; d<=ndim; d++)); do
        if [[ $month -eq $CURRENT_MONTH && $year -eq $CURRENT_YEAR && $d -eq $TODAY ]]; then
            echo "[$d]"
        else
            echo "$d"
        fi
    done

    # Padding
    local total_days_cells=$((fdow + ndim))
    local rem=$(( (7 - (total_days_cells % 7)) % 7 ))
    for ((i=0; i<rem; i++)); do
        echo " "
    done

    # Nav
    echo "◀"
    echo " "
    echo " "
    echo "⟳"
    echo " "
    echo " "
    echo "▶"
}

# Create a temporary calendar.rasi
cat << 'INNEREOF' > /home/dionovan/.config/rofi/calendar_test_grid.rasi
/* Rofi Calendar Theme — Gruvbox Dark (Flat Style) */

* {
    bg0:        #282828;
    bg1:        #3c3836;
    bg2:        #504945;
    fg0:        #fbf1c7;
    fg1:        #ebdbb2;

    gruvyellow: #fabd2f;
    gruvaqua:   #8ec07c;
    gruvorange: #fe8019;

    background-color: #282828;
    text-color:       #ebdbb2;
    border:    0;
    margin:    0;
    padding:   0;
    spacing:   0;
}

window {
    width:            320px;
    background-color: #282828;
    border:           0px;
    border-radius:    0px;
    padding:          15px;
}

mainbox {
    background-color: transparent;
    children:         [ inputbar, listview ];
    padding:          0px;
    spacing:          0px;
}

inputbar {
    enabled:          true;
    background-color: transparent;
    padding:          0px 0px 15px 0px;
    children:         [ prompt ];
}

prompt {
    background-color: transparent;
    text-color:       #fabd2f;
    font:             "JetBrainsMono Nerd Font Bold 12";
    horizontal-align: 0.5;
    expand:           true;
}

listview {
    background-color: transparent;
    columns:          7;
    lines:            8;
    spacing:          6px;
    scrollbar:        false;
    border:           0px;
    padding:          0px;
    fixed-height:     true;
    dynamic:          false;
}

element {
    background-color: transparent;
    text-color:       #ebdbb2;
    padding:          8px 0px;
    border-radius:    0px;
    cursor:           pointer;
}

element.normal.normal {
    background-color: transparent;
    text-color:       #ebdbb2;
}

element.selected.normal {
    background-color: #8ec07c;
    text-color:       #282828;
    border-radius:    0px;
}

element.normal.urgent {
    background-color: transparent;
    text-color:       #8ec07c;
    cursor:           pointer;
}

element.selected.urgent {
    background-color: #8ec07c;
    text-color:       #282828;
    border-radius:    0px;
}

element.normal.active {
    background-color: transparent;
    text-color:       #fabd2f;
    border-radius:    0px;
}

element.selected.active {
    background-color: #8ec07c;
    text-color:       #282828;
    border-radius:    0px;
}

element-text {
    background-color: inherit;
    text-color:       inherit;
    vertical-align:   0.5;
    horizontal-align: 0.5;
    font:             "JetBrainsMono Nerd Font Bold 10";
}
INNEREOF

MENU=$(generate_calendar "$YEAR" "$MONTH")
num_lines=$(printf "%s" "$MENU" | wc -l)
N_grid=$((num_lines-7))
urgent_indices="$((N_grid)),$((N_grid+3)),$((N_grid+6))"
active_indices="0,1,2,3,4,5,6"

zm=$(zpad "$MONTH")
month_name=$(date -d "${YEAR}-${zm}-01" +"%B %Y")
fdow=$(date -d "${YEAR}-${zm}-01" +%w)

# Start selection on today
selected_idx=$((7 + fdow + TODAY - 1))

# Run rofi
rofi -dmenu \
    -theme /home/dionovan/.config/rofi/calendar_test_grid.rasi \
    -p "📅  $month_name" \
    -no-custom \
    -a "$active_indices" \
    -u "$urgent_indices" \
    -selected-row "$selected_idx" \
    -format s &
ROFIPID=$!
sleep 1.0
maim /home/dionovan/.gemini/antigravity-cli/brain/54252fb6-f822-4649-80b6-70c42fc9367e/test_calendar_grid.png
kill $ROFIPID
pkill -f rofi
rm /home/dionovan/.config/rofi/calendar_test_grid.rasi
