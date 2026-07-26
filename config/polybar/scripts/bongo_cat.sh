#!/usr/bin/env bash

# Cute Bongo Cat animation frames (perfectly aligned spacing to prevent shifting)
f1=" ฅ(=^•ω•^=)ฅ "
f2=" ฅ(=^•ω•^=)ﾉ "
f3=" ﾍ(=^•ω•^=)ฅ "

cpu_usage=0
count=0

# Pre-read stats
read -r cpu a b c d e f g h i j < /proc/stat
prev_active=$((a + b + c + f + g + h + i + j))
prev_total=$((a + b + c + d + e + f + g + h + i + j))

while true; do
    # Update CPU usage every 8 frames to avoid high overhead
    if [ "$count" -eq 0 ]; then
        read -r cpu a b c d e f g h i j < /proc/stat
        active=$((a + b + c + f + g + h + i + j))
        total=$((a + b + c + d + e + f + g + h + i + j))
        diff_active=$((active - prev_active))
        diff_total=$((total - prev_total))
        if [ "$diff_total" -gt 0 ]; then
            cpu_usage=$(( (diff_active * 100) / diff_total ))
        fi
        prev_active=$active
        prev_total=$total
        count=8
    fi
    count=$((count - 1))

    # Determine animation speed based on CPU usage
    if [ "$cpu_usage" -lt 15 ]; then
        # Idle / Slow bongo tapping
        echo "$f1"
        sleep 0.8
    elif [ "$cpu_usage" -lt 45 ]; then
        # Normal speed
        echo "$f2"
        sleep 0.2
        echo "$f1"
        sleep 0.2
        echo "$f3"
        sleep 0.2
        echo "$f1"
        sleep 0.2
    else
        # Hyper bongo tapping (High CPU usage)
        echo "$f2"
        sleep 0.08
        echo "$f3"
        sleep 0.08
    fi
done
