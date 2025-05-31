#!/bin/bash

# Check if Waybar is running
if pgrep -x "waybar" >/dev/null; then
  # Send signal to toggle visibility
  pkill -USR1 waybar
else
  # Start Waybar if not running
  waybar &
fi
