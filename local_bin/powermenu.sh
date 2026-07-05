#!/usr/bin/env bash

# Pilihan menu menggunakan ikon dan teks
op_reboot="  Reboot"
op_shutdown="  Shutdown"
op_sleep="  Sleep"
op_hibernate="  Hibernate"

# Gabungkan pilihan
pilihan="$op_reboot\n$op_shutdown\n$op_sleep\n$op_hibernate"

# Lempar ke Rofi dengan styling vertikal text + icon, hover effect, dan cursor pointer
opsi=$(echo -e "$pilihan" | rofi -dmenu -i \
  -hover-select -me-select-entry "" -me-accept-entry MousePrimary \
  -theme-str '
    window {
        width: 380px;
        border: 2px;
        border-color: @border-color;
        border-radius: 16px;
        padding: 20px;
        children: [ listview ];
    }
    listview {
        spacing: 10px;
        lines: 4;
        columns: 1;
        border: 0px;
    }
    element {
        padding: 12px 20px 12px 75px;
        border-radius: 10px;
        cursor: pointer;
    }
    element-text {
        font: "JetBrainsMono Nerd Font Bold 14";
        horizontal-align: 0.0;
        vertical-align: 0.5;
        cursor: pointer;
        text-color: inherit;
    }
    element selected {
        background-color: @selected-normal-background;
        text-color: @selected-normal-foreground;
    }
  ')

# Eksekusi perintah berdasarkan pilihan
case "$opsi" in
    "$op_shutdown")
        systemctl poweroff
        ;;
    "$op_reboot")
        systemctl reboot
        ;;
    "$op_sleep")
        systemctl suspend
        ;;
    "$op_hibernate")
        systemctl hibernate
        ;;
esac
