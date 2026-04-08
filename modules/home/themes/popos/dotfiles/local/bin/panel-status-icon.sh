#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  battery)
    BAT=$(upower -e | grep -m1 'BAT' || true)
    if [ -z "${BAT}" ]; then
      # No battery present: hide icon
      # Or: exit 0 to emit nothing at all
      echo "<txt class=\"hidden\"></txt>"
      exit 0
    fi

    PCT=$(upower -i "$BAT" | awk '/percentage/ {gsub(/%/,"",$2); print $2}')
    STATE=$(upower -i "$BAT" | awk '/state/ {print $2}')

    if   [ "$PCT" -le 5 ];   then ICON=$(printf '\uf244')
    elif [ "$PCT" -le 25 ];  then ICON=$(printf '\uf243')
    elif [ "$PCT" -le 50 ];  then ICON=$(printf '\uf242')
    elif [ "$PCT" -le 75 ];  then ICON=$(printf '\uf241')
    else                          ICON=$(printf '\uf240')
    fi

    if [ "$STATE" = "charging" ]; then
      ICON=$(printf '\uf1e6')
    fi

    echo "<txt>${ICON}</txt>"
    ;;

  wifi)
    WIFI_DEV=$(nmcli -t -f DEVICE,TYPE dev | awk -F: '$2=="wifi"{print $1; exit}' || true)
    if [ -z "${WIFI_DEV}" ]; then
      echo "<txt class=\"hidden\"></txt>"
      exit 0
    fi

    if nmcli -t -f TYPE,STATE con show --active | awk -F: '$1=="ethernet" && $2=="activated"{found=1} END{exit !found}'; then
      echo "<txt class=\"hidden\"></txt>"
      exit 0
    fi

    STATE=$(nmcli -t -f GENERAL.STATE dev show "$WIFI_DEV" | awk -F: '{print $2}' | awk '{print $1}')

    if [ "$STATE" -lt 100 ]; then
      # Disconnected
      ICON=$(printf '\U000F092E')   # example: some wifi-off glyph; replace with your choice
      echo "<txt>${ICON}</txt>"
      exit 0
    fi

    SIGNAL=$(nmcli -f IN-USE,SIGNAL dev wifi | awk '$1=="*"{print $2}')
    SIGNAL=${SIGNAL:-0}

    # Replace \ufxyz with glyphs you actually want; avoid surrogate pairs
    if   [ "$SIGNAL" -le 25 ];  then ICON=$(printf '\U000F091F')  # weak
    elif [ "$SIGNAL" -le 50 ];  then ICON=$(printf '\U000F0922')  # medium
    elif [ "$SIGNAL" -le 75 ];  then ICON=$(printf '\U000F0925')  # good
    else                             ICON=$(printf '\U000F0928')  # excellent
    fi

    echo "<txt>${ICON}</txt>"
    ;;

  sound)
    VOL=$(pamixer --get-volume 2>/dev/null || echo 0)
    MUTED=$(pamixer --get-mute 2>/dev/null || echo "false")

    if [ "$MUTED" = "true" ] || [ "$VOL" -eq 0 ]; then
      ICON=$(printf '\uf026')
    elif [ "$VOL" -le 33 ]; then
      ICON=$(printf '\uf027')
    else
      ICON=$(printf '\uf028')
    fi

    echo "<txt>${ICON}</txt>"
    ;;

  *)
    echo "<txt>?</txt>"
    ;;
esac