#!/bin/bash

set -euo pipefail

STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/hypr_style_mode"

apply_minimal() {
  hyprctl keyword general:gaps_in 0
  hyprctl keyword general:gaps_out 0
  hyprctl keyword decoration:rounding 0
  hyprctl keyword animations:enabled false
  echo "minimal" >"$STATE_FILE"
}

apply_fancy() {
  hyprctl keyword general:gaps_in 6
  hyprctl keyword general:gaps_out 12
  hyprctl keyword decoration:rounding 12
  hyprctl keyword animations:enabled true
  echo "fancy" >"$STATE_FILE"
}

if [[ -f "$STATE_FILE" ]]; then
  mode="$(<"$STATE_FILE")"
else
  mode="minimal"
fi

if [[ "$mode" == "fancy" ]]; then
  apply_minimal
else
  apply_fancy
fi
