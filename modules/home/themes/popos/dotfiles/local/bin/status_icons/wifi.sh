#!/usr/bin/env bash
set -euo pipefail

WIFI_DEVICE_IDENTIFIER=${1}
if [[ -z "${WIFI_DEVICE_IDENTIFIER}" ]]; then
  exit 0
fi

WIFI_STATE=$(nmcli -t -f GENERAL.STATE dev show "$WIFI_DEVICE_IDENTIFIER" | awk -F: '{print $2}' | awk '{print $1}')

if [ "$WIFI_STATE" -lt 100 ]; then
    ICON=$(printf '\U000F092E')
else
    SIGNAL=$(nmcli -f IN-USE,SIGNAL dev wifi | awk '$1=="*"{print $2}')
    SIGNAL=${SIGNAL:-0}

    # Replace \ufxyz with glyphs you actually want; avoid surrogate pairs
    if   [ "$SIGNAL" -le 25 ];  then 
        ICON=$(printf '\U000F091F')  # weak
        COLOR="#ff0000"
    elif [ "$SIGNAL" -le 50 ]; then
        ICON=$(printf '\U000F0922')  # medium
        COLOR="#ffff00"

    elif [ "$SIGNAL" -le 75 ];  then 
        ICON=$(printf '\U000F0925')  # good
        COLOR="#cdffcd"
    else                             
        ICON=$(printf '\U000F0928')  # excellent
        COLOR="#00ff00"
    fi
fi

~/.local/bin/status_icons/build_icon.sh \
  --segment "${ICON}" --color "${COLOR}"