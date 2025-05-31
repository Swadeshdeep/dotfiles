#!/bin/bash

# Handle different modes
MODE="$1"

FILENAME="$(xdg-user-dir PICTURES)/Screenshots/$(date +%s)_grim.png"
mkdir -p "$(dirname "$FILENAME")"

case "$MODE" in
full)
  grim "$FILENAME"
  ;;
region)
  grim -g "$(slurp)" "$FILENAME"
  ;;
region-o)
  grim -g "$(slurp -o)" "$FILENAME"
  ;;
*)
  echo "Usage: screenshot.sh [full|region|region-o]"
  exit 1
  ;;
esac
