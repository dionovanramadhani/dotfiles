#!/usr/bin/env bash

# Pilihan menu menggunakan ikon dan teks
op_lock="  Lock"
op_logout="  Log out"
op_sleep="  Sleep"
op_hibernate="  Hibernate"
op_reboot="  Reboot"
op_shutdown="  Shutdown"

# Gabungkan pilihan
pilihan="$op_lock\n$op_logout\n$op_sleep\n$op_hibernate\n$op_reboot\n$op_shutdown"

# Lempar ke Rofi dengan styling vertikal text + icon, hover effect, dan cursor pointer
opsi=$(echo -e "$pilihan" | rofi -dmenu -i \
  -hover-select -me-select-entry "" -me-accept-entry MousePrimary \
  -theme-str '
    window {
        width: 260px;
        border: 0px;
        border-radius: 0px;
        padding: 20px;
        background-color: @background;
        children: [ listview ];
    }
    listview {
        spacing: 8px;
        lines: 6;
        columns: 1;
        border: 0px;
        background-color: transparent;
    }
    element {
        padding: 10px 15px;
        border-radius: 0px;
        cursor: pointer;
        background-color: transparent;
        text-color: @foreground;
    }
    element-text {
        font: "JetBrainsMono Nerd Font Bold 12";
        horizontal-align: 0.0;
        vertical-align: 0.5;
        cursor: pointer;
        text-color: inherit;
        background-color: transparent;
    }
    element selected {
        background-color: @selected-normal-background;
        text-color: @selected-normal-foreground;
    }
  ')

# Eksekusi perintah berdasarkan pilihan
case "$opsi" in
    "$op_lock")
        dbus-send --system --print-reply --dest=org.freedesktop.DisplayManager /org/freedesktop/DisplayManager/Seat0 org.freedesktop.DisplayManager.Seat.SwitchToGreeter
        ;;
    "$op_logout")
        bspc quit
        ;;
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
