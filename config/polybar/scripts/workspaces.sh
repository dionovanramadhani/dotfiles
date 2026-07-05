#!/usr/bin/env bash
# workspaces.sh — real-time workspace icons via bspc subscribe
# pacman=U+F0BAF  ghost=U+F02A0

PACMAN='󰮯'
GHOST='󰊠'

COLORS=(
    "#83a598"   # blue
    "#8ec07c"   # cyan
    "#b8bb26"   # green
    "#fe8019"   # orange
    "#d3869b"   # purple
    "#fb4934"   # red
    "#fabd2f"   # yellow
)

render() {
    local CURRENT NUM OUT="" ci=0
    CURRENT=$(xprop -root _NET_CURRENT_DESKTOP 2>/dev/null | awk '{print $3}')
    NUM=$(xprop -root _NET_NUMBER_OF_DESKTOPS 2>/dev/null | awk '{print $3}')

    [[ -z "$CURRENT" || -z "$NUM" ]] && return

    for ((i=0; i<NUM; i++)); do
        if [[ $i -eq $CURRENT ]]; then
            OUT+="%{A1:bspc desktop -f '^$((i+1))':}%{F#fabd2f}%{T4}${PACMAN}%{T-}%{F-}%{A}"
        else
            COLOR="${COLORS[$((ci % ${#COLORS[@]}))]}"
            OUT+="%{A1:bspc desktop -f '^$((i+1))':}%{F${COLOR}}%{T4}${GHOST}%{T-}%{F-}%{A}"
            ci=$((ci+1))
        fi
        OUT+="%{O14}"
    done

    printf "%s\n" "$OUT"
}

# Output state awal
render

# Subscribe ke bspwm — update instan setiap pindah desktop
bspc subscribe desktop_focus | while read -r _; do
    render
done
