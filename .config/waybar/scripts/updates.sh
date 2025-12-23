#!/usr/bin/env bash

# Check if command exists
_checkCommandExists() {
  command -v "$1" >/dev/null 2>&1
}

script_name=$(basename "$0")

# Prevent multiple instances
instance_count=$(pgrep -fc "$script_name")
if [ "$instance_count" -gt 1 ]; then
  sleep "$instance_count"
fi

# -----------------------------------------------------
# Thresholds
# -----------------------------------------------------

threshold_green=0
threshold_yellow=25
threshold_red=100

# -----------------------------------------------------
# Check for updates
# -----------------------------------------------------

updates=0

# Arch Linux
if _checkCommandExists pacman; then

  # Wait for pacman lock
  pacman_lock="/var/lib/pacman/db.lck"
  checkup_lock="${TMPDIR:-/tmp}/checkup-db-${UID}/db.lck"

  while [ -f "$pacman_lock" ] || [ -f "$checkup_lock" ]; do
    sleep 1
  done

  # AUR helper
  if _checkCommandExists paru; then
    aur_helper="paru"
  elif _checkCommandExists yay; then
    aur_helper="yay"
  else
    aur_helper=""
  fi

  updates_aur=0
  if [ -n "$aur_helper" ]; then
    updates_aur=$("$aur_helper" -Qum 2>/dev/null | wc -l)
  fi

  updates_pacman=0
  if _checkCommandExists checkupdates; then
    updates_pacman=$(checkupdates 2>/dev/null | wc -l)
  fi

  updates=$((updates_aur + updates_pacman))

# Fedora
elif _checkCommandExists dnf; then
  updates=$(dnf check-update -q | grep -c '^[a-z0-9]')
fi

# -----------------------------------------------------
# Output JSON for Waybar
# -----------------------------------------------------

css_class="green"

if [ "$updates" -gt "$threshold_yellow" ]; then
  css_class="yellow"
fi

if [ "$updates" -gt "$threshold_red" ]; then
  css_class="red"
fi

printf '{"text":"%s","alt":"%s","tooltip":"Click to update your system","class":"%s"}' \
  "$updates" "$updates" "$css_class"
