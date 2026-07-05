#!/usr/bin/env bash
# calendar.sh — rofi calendar dengan navigasi bebas (tanpa exec, gunakan while loop)

TODAY=$(date +%-d)
CURRENT_MONTH=$(date +%-m)
CURRENT_YEAR=$(date +%Y)

YEAR=$CURRENT_YEAR
MONTH=$CURRENT_MONTH

SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"

zpad() { printf "%02d" "$1"; }

# ── Generate kalender ────────────────────────────────────────────────────────
generate_calendar() {
    local year=$1 month=$2
    local zm; zm=$(zpad "$month")
    local month_name; month_name=$(date -d "${year}-${zm}-01" +"%B %Y")

    # Prev / next
    local pm py nm ny
    if [[ $month -eq 1  ]]; then pm=12; py=$((year-1)); else pm=$((month-1)); py=$year; fi
    if [[ $month -eq 12 ]]; then nm=1;  ny=$((year+1)); else nm=$((month+1)); ny=$year; fi
    local pname nname
    pname=$(date -d "${py}-$(zpad $pm)-01" +"%B %Y")
    nname=$(date -d "${ny}-$(zpad $nm)-01" +"%B %Y")

    # First day of week (0=Sun) dan jumlah hari
    local fdow ndim
    fdow=$(date -d "${year}-${zm}-01" +%w)
    ndim=$(date -d "${year}-${zm}-01 +1 month -1 day" +%d)

    # Tiap sel = 5 karakter: "  27 " atau " [27]" (today)
    local cells=()
    for ((i=0; i<fdow; i++)); do cells+=("     "); done   # 5 spaces

    local d
    for ((d=1; d<=ndim; d++)); do
        if [[ $month -eq $CURRENT_MONTH && $year -eq $CURRENT_YEAR && $d -eq $TODAY ]]; then
            cells+=("$(printf '[%2d] ' "$d")")   # [27]  → 5 chars
        else
            cells+=("$(printf ' %2d  ' "$d")")   # " 27 " → 5 chars
        fi
    done

    # ── Header ────────────────────────────────────────────────────────────────
    # Semua baris 35 karakter (7×5), di-pad kiri-kanan agar centered di window
    local SEP="───────────────────────────────────"   # 35 chars
    local HDR=" Su   Mo   Tu   We   Th   Fr   Sa "  # 35 chars

    printf " 📅  %s\n"      "$month_name"
    printf " %s\n"          "$SEP"
    printf " %s\n"          "$HDR"
    printf " %s\n"          "$SEP"

    # ── Grid ──────────────────────────────────────────────────────────────────
    local n=${#cells[@]} i=0
    while [[ $i -lt $n ]]; do
        local row=""
        for ((j=0; j<7 && i+j<n; j++)); do
            row+="${cells[$((i+j))]}"
        done
        # Pad baris agar selalu 35 chars
        printf " %-35s\n" "$row"
        i=$((i+7))
    done

    # ── Navigasi ──────────────────────────────────────────────────────────────
    printf " %s\n"          "$SEP"
    printf " ◀  %-31s\n"   "$pname"
    printf " ▶  %-31s\n"   "$nname"
    printf " ⟳  This Month\n"
}

# ── Main loop: tetap hidup sampai user Esc ────────────────────────────────────
while true; do
    MENU=$(generate_calendar "$YEAR" "$MONTH")

    CHOICE=$(printf "%s" "$MENU" | rofi \
        -dmenu \
        -theme ~/.config/rofi/calendar.rasi \
        -p "" \
        -no-custom \
        -format s)

    # Match prefix baris navigasi (dimulai dengan spasi + simbol)
    case "$CHOICE" in
        " ◀"*)
            if [[ $MONTH -eq 1  ]]; then MONTH=12; YEAR=$((YEAR-1)); else MONTH=$((MONTH-1)); fi
            ;;
        " ▶"*)
            if [[ $MONTH -eq 12 ]]; then MONTH=1;  YEAR=$((YEAR+1)); else MONTH=$((MONTH+1)); fi
            ;;
        " ⟳"*)
            YEAR=$CURRENT_YEAR
            MONTH=$CURRENT_MONTH
            ;;
        *)
            # Esc atau klik baris non-navigasi → keluar
            exit 0
            ;;
    esac
done
