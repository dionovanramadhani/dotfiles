#!/usr/bin/env bash
export DISPLAY=:0
# Backup calendar.rasi temporarily
cp /home/dionovan/.config/rofi/calendar.rasi /home/dionovan/.config/rofi/calendar.rasi.tmp

# Write config with width 420px and centered element-text
cat << 'INNEREOF' > /home/dionovan/.config/rofi/calendar.rasi
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
    width:            420px;
    background-color: #282828;
    border:           0px;
    border-radius:    0px;
    padding:          15px;
}

mainbox {
    background-color: transparent;
    children:         [ listview ];
    padding:          10px 6px;
    spacing:          0px;
}

inputbar {
    enabled: false;
}

listview {
    background-color: transparent;
    lines:            13;
    columns:          1;
    spacing:          0px;
    scrollbar:        false;
    border:           0px;
    padding:          0px;
    fixed-height:     false;
    dynamic:          true;
}

/* Semua baris kalender */
element {
    background-color: transparent;
    text-color:       #ebdbb2;
    padding:          6px 12px;
    border-radius:    0px;
    cursor:           default;
    orientation:      horizontal;
    spacing:          0px;
    expand:           true;
}

element.normal.normal {
    background-color: transparent;
    text-color:       #ebdbb2;
}

/* Baris yang di-hover (tapi bukan navigasi) */
element.selected.normal {
    background-color: transparent;
    text-color:       #ebdbb2;
}

/* Baris navigasi ◀ ▶ ⟳ */
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

/* Header baris (📅 bulan tahun) pakai active */
element.normal.active {
    background-color: #3c3836;
    text-color:       #fabd2f;
    border-radius:    0px;
}

element.selected.active {
    background-color: #3c3836;
    text-color:       #fabd2f;
}

element-text {
    background-color: transparent;
    text-color:       inherit;
    vertical-align:   0.5;
    horizontal-align: 0.5;
    expand:           true;
    font:             "JetBrainsMono Nerd Font Bold 10";
    highlight:        bold;
}
INNEREOF

# Run calendar.sh in background
/home/dionovan/.config/polybar/scripts/calendar.sh &
CALPID=$!
sleep 1.0
maim /home/dionovan/.gemini/antigravity-cli/brain/54252fb6-f822-4649-80b6-70c42fc9367e/test_calendar_width.png
kill $CALPID
pkill -f rofi

# Restore calendar.rasi
mv /home/dionovan/.config/rofi/calendar.rasi.tmp /home/dionovan/.config/rofi/calendar.rasi
