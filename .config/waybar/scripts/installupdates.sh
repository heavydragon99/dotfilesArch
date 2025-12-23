#!/usr/bin/env bash
#    ____         __       ____               __     __
#   /  _/__  ___ / /____ _/ / / __ _____  ___/ /__ _/ /____ ___
#  _/ // _ \(_-</ __/ _ `/ / / / // / _ \/ _  / _ `/ __/ -_|_-<
# /___/_//_/___/\__/\_,_/_/_/  \_,_/ .__/\_,_/\_,_/\__/\__/___/
#                                 /_/
#

# ---------------------------
# Helper: check if command exists
# ---------------------------
_checkCommandExists() {
  cmd="$1"
  if ! command -v "$cmd" >/dev/null; then
    echo 1
    return
  fi
  echo 0
  return
}

# ---------------------------
# Load colors from ~/.config/hypr/colors
# ---------------------------
COLOR_FOLDER="$HOME/.config/hypr/colors"
primarycolor="cyan"
onsurfacecolor="white"

[[ -f "$COLOR_FOLDER/primary" ]] && primarycolor=$(<"$COLOR_FOLDER/primary")
[[ -f "$COLOR_FOLDER/onsurface" ]] && onsurfacecolor=$(<"$COLOR_FOLDER/onsurface")

# ---------------------------
# Display title with figlet (fallback to echo)
# ---------------------------
sleep 1
clear
if [[ $(_checkCommandExists "figlet") == 0 ]]; then
  figlet -f smslant "Updates"
else
  echo "=== Updates ==="
fi
echo

# ---------------------------
# Confirm start using gum (fallback to read)
# ---------------------------
if [[ $(_checkCommandExists "gum") == 0 ]]; then
  if gum confirm --selected.background="$primarycolor" --prompt.foreground="$onsurfacecolor" "DO YOU WANT TO START THE UPDATE NOW?"; then
    echo ":: Update started..."
  else
    echo ":: Update canceled."
    exit
  fi
else
  read -rp "DO YOU WANT TO START THE UPDATE NOW? [y/N]: " answer
  case "$answer" in
  [Yy]*) echo ":: Update started..." ;;
  *)
    echo ":: Update canceled."
    exit
    ;;
  esac
fi

# ---------------------------
# Arch Update
# ---------------------------
yay_installed="false"
paru_installed="false"

[[ $(_checkCommandExists "yay") == 0 ]] && yay_installed="true"
[[ $(_checkCommandExists "paru") == 0 ]] && paru_installed="true"

if [[ $yay_installed == "true" ]] && [[ $paru_installed == "false" ]]; then
  yay -Syu --noconfirm
elif [[ $yay_installed == "false" ]] && [[ $paru_installed == "true" ]]; then
  paru -Syu --noconfirm
else
  yay -Syu --noconfirm
fi

# ---------------------------
# Flatpak updates (if available)
# ---------------------------
if [[ $(_checkCommandExists "flatpak") == 0 ]]; then
  echo ":: Searching for Flatpak updates..."
  flatpak update -y
fi

# ---------------------------
# Reload Waybar (if running)
# ---------------------------
if pgrep -x "waybar" >/dev/null; then
  pkill -RTMIN+1 waybar
fi

# ---------------------------
# Finish
# ---------------------------
echo ":: Update complete! Press [ENTER] to close."
read -r
