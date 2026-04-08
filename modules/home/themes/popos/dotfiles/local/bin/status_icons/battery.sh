#!/usr/bin/env bash
set -euo pipefail

BATTERY=40   #$(awk '{print $1}' /sys/class/power_supply/BAT*/capacity)
CHARGING=0   # TODO: real value

if [ "$BATTERY" -lt 5 ]; then
    ICON=$(printf '\uf244')
elif [ "$BATTERY" -lt 25 ]; then
    ICON=$(printf '\uf243')
elif [ "$BATTERY" -lt 50 ]; then
    ICON=$(printf '\uf242')
elif [ "$BATTERY" -lt 75 ]; then
    ICON=$(printf '\uf241')
else
    ICON=$(printf '\uf240')
fi

[ "$CHARGING" -eq 1 ] && ICON="${ICON} $(printf '\uf0e7')"

if [ "$CHARGING" -eq 1 ]; then
  COLOR="#cdffcd"
elif [ "$BATTERY" -lt 25 ]; then
  COLOR="#ff0000"
elif [ "$BATTERY" -gt 75 ]; then
  COLOR="#cdffcd"
else
  COLOR="#ffffff"
fi

~/.local/bin/status_icons/build_icon.sh \
  --pill "#39546f" \
  --segment "${ICON}" --color "${COLOR}" \
  --segment " ${BATTERY}%" --color "#ffffff"