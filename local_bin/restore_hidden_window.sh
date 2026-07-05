#!/bin/bash

# Restore and focus a hidden window by its ID
WINDOW_ID="$1"

if [ -n "$WINDOW_ID" ]; then
    bspc node "$WINDOW_ID" -g hidden=off
    bspc node "$WINDOW_ID" -f
fi
