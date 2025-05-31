#!/bin/bash

TOGGLE_FILE="$HOME/.config/waybar/.network_speed_toggle"

if [ -f "$TOGGLE_FILE" ]; then
    rm "$TOGGLE_FILE"
    echo '{"class": "visible"}'
else
    touch "$TOGGLE_FILE"
    echo '{"class": "hidden"}'
fi
