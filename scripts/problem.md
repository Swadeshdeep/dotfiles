Run this sequence:

pkill -x spotify
pkill -x swaync
supergfxctl -m Integrated

If it still hangs or fails, check the real blocker:

fuser -v /dev/nvidiactl /dev/nvidia-modeset /dev/dri/card0 /dev/dri/renderD129

If it shows Hyprland, the compositor is holding NVIDIA. Then save your work and log out of Hyprland, or reboot, then switch again:

supergfxctl -m Integrated

Useful verification:

supergfxctl -g
supergfxctl -S
nvidia-smi

Expected result: supergfxctl -g should say Integrated, and nvidia-smi should show no active NVIDIA device/processes.
