#!/usr/bin/env bash

# Path to keybindings config file
config_file="$HOME/.config/hypr/conf/keybinds.conf"
echo "Reading from: $config_file"

# Parse keybindings
keybinds=$(awk -F'=' '
    $1 ~ /^bind/ {
        line=$0
        gsub(/\$mainMod/, "SUPER", line)
        gsub(/^bind[[:space:]]*/, "", line)
        split(line, arr, "=")
        key=arr[1]; cmd=arr[2]
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", key)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", cmd)
        print key "  →  " cmd
    }
' "$config_file")

# Optional tiny delay
sleep 0.2

# Show in Rofi
rofi -dmenu -i -markup -eh 2 -replace -p "Keybinds" -config ~/.config/rofi/config-compact.rasi <<<"$keybinds"
