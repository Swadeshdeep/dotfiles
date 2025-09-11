#!/bin/bash
# Handle different modes
MODE="$1"

case "$MODE" in
full)
  grim - | wl-copy
  ;;
region)
  grim -g "$(slurp)" - | wl-copy
  ;;
region-o)
  grim -g "$(slurp -o)" - | wl-copy
  ;;
*)
  echo "Usage: screenshot.sh [full|region|region-o]"
  exit 1
  ;;
esac

# Show notification that screenshot was copied
notify-send "Screenshot" "Screenshot copied to clipboard"
