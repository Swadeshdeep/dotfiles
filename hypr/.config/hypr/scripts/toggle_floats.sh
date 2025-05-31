#!/bin/bash

active_ws_id=$(hyprctl activewindow -j | jq '.workspace.id')
hyprctl clients -j | jq -r ".[] | select(.workspace.id == $active_ws_id) | .address" | while read -r win; do
  hyprctl dispatch togglefloating address:$win
done
