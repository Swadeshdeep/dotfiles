#!/bin/bash

# Kill any existing xremap process
pkill xremap

# Wait a moment to ensure the process is terminated
sleep 0.5

# Restart xremap with the specified config file
xremap --watch ~/.config/xremap/config.yml &
