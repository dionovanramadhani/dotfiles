#!/usr/bin/env bash
export DISPLAY=:0
# Create a modified version of calendar.sh for testing
cat << 'INNEREOF' > /home/dionovan/.config/polybar/scripts/calendar_test.sh
#!/usr/bin/env bash
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
    local cells=()
    for ((i=0; i<fdow; i++)); do cells+=("     "); done
    local d
    for ((d=1; d<=ndim; d++)); do
        if [[ $month -eq $CURRENT_MONTH && $year -eq $CURRENT_YEAR && $d -eq $TODAY ]]; then
            cells+=("$(printf '[%2d] ' "$d")")
        else
            cells+=("$(printf ' %2d  ' "$d")")
        fi
    done
    local SEP="───────────────────────────────────"
    local HDR=" Su   Mo   Tu   We   Th   Fr   Sa "
    printf " 📅  %s\n"      "$month_name"
    printf " %s\n"          "$SEP"
    printf " %s\n"          "$HDR"
    printf " %s\n"          "$SEP"
    local n=${#cells[@]} i=0
    while [[ $i -lt $n ]]; do
        local row=""
        for ((j=0; j<7 && i+j<n; j++)); do
            row+="${cells[$((i+j))]}"
        done
        printf " %-35s\n" "$row"
        i=$((i+7))
    done
    printf " %s\n"          "$SEP"
    printf " ◀  %-31s\n"   "$pname"
    printf " ▶  %-31s\n"   "$nname"
    printf " ⟳  This Month\n"
}

while true; do
    MENU=$(generate_calendar "$YEAR" "$MONTH")
    num_lines=$(printf "%s" "$MENU" | wc -l)
    urgent_indices="$((num_lines-3)),$((num_lines-2)),$((num_lines-1))"
    
    CHOICE=$(printf "%s" "$MENU" | rofi \
        -dmenu \
        -theme ~/.config/rofi/calendar.rasi \
        -p "" \
        -no-custom \
        -a 0 \
        -u "$urgent_indices" \
        -selected-row 11 \
        -format s)
    exit 0
done
INNEREOF
chmod +x /home/dionovan/.config/polybar/scripts/calendar_test.sh
/home/dionovan/.config/polybar/scripts/calendar_test.sh &
CALPID=$!
sleep 1.0
maim /home/dionovan/.gemini/antigravity-cli/brain/54252fb6-f822-4649-80b6-70c42fc9367e/test_calendar_nav.png
kill $CALPID
pkill -f rofi
rm /home/dionovan/.config/polybar/scripts/calendar_test.sh
