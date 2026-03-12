#!/usr/bin/env bash

# Mic hardware mute indicator for Waybar.
# Your G14 does not expose a dedicated mic LED in /sys/class/leds,
# so we infer the state from ALSA mixer controls that the hardware key toggles.

ICON_ON=""   # mic enabled
ICON_OFF=""  # mic muted

# Try a list of likely ALSA controls the hardware key might toggle.
CONTROLS=(
  "Capture"
  "Mic"
  "Internal Mic"
  "Capture Switch"
)

for ctl in "${CONTROLS[@]}"; do
  # Query the control; suppress errors if it doesn't exist.
  out=$(amixer get "$ctl" 2>/dev/null) || continue

  # Look for a line with on/off state, e.g.:
  #   Front Left: Capture 80 [on]
  #   Mono: Capture 0 [off]
  state=$(awk -F'[][]' '/(Left:|Right:|Mono:)/ {print $4; exit}' <<< "$out")

  if [ "$state" = "off" ]; then
    echo "$ICON_OFF"
    exit 0
  elif [ "$state" = "on" ]; then
    echo "$ICON_ON"
    exit 0
  fi
done

# If we couldn't detect anything, assume mic enabled.
echo "$ICON_ON"


