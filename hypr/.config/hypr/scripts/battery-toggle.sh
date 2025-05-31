#!/bin/bash
# First, create the battery toggle script
# Save this as ~/battery-toggle.sh

# Get current battery limit
current_limit=$(asusctl -c | grep "Charge limit" | awk '{print $3}' | tr -d '%')

# Toggle between 60% and 100%
if [ "$current_limit" -eq 100 ]; then
  # Set to 60%
  asusctl -c 60
  notify-send "Battery Limit" "Battery limit set to 60%" --icon=battery
else
  # Set to 100%
  asusctl -c 100
  notify-send "Battery Limit" "Battery limit set to 100%" --icon=battery
fi
