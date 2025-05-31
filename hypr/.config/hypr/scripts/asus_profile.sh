#!/bin/bash

# Cycle through Asus profiles
asusctl profile -n

# Get the current profile
PROFILE=$(asusctl profile -p | awk '{print $NF}')

# Send a notification with Dunst
notify-send "Asus Profile Changed" "Current Profile: $PROFILE" -r 9999 -u low
