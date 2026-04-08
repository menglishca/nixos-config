#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
    battery)
    # Find a battery device via upower
    BAT=$(upower -e | grep -m1 'BAT')
    if [ -z "$BAT" ]; then
      # No battery present: hide icon
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
    # Any wifi device?
    WIFI_DEV=$(nmcli -t -f DEVICE,TYPE dev | awk -F: '$2=="wifi"{print $1; exit}')
    if [ -z "$WIFI_DEV" ]; then
      # No wifi hardware: hide icon
      echo "<txt class=\"hidden\"></txt>"
      exit 0
    fi

    # Any active wired connection? If yes, optionally hide wifi
    if nmcli -t -f TYPE,STATE con show --active | awk -F: '$1=="ethernet" && $2=="activated"{found=1} END{exit !found}'; then
      echo "<txt class=\"hidden\"></txt>"
      exit 0
    fi

    # Check wifi device state: 30 = disconnected, 100 = connected, etc. [web:379]
    STATE=$(nmcli -t -f GENERAL.STATE dev show "$WIFI_DEV" | awk -F: '{print $2}' | awk '{print $1}')

    if [ "$STATE" -lt 100 ]; then
      # Disconnected: show a "wifi off" icon
      ICON=$(printf '\udb82\udd2b')  # pick an mdi-wifi-off / similar glyph
      echo "<txt>${ICON}</txt>"
    fi

    # Very rough example using nmcli; replace logic as you like
    SIGNAL=$(nmcli -f IN-USE,SIGNAL dev wifi | awk '$1=="*"{print $2}')
    SIGNAL=${SIGNAL:-0}

    if   [ "$SIGNAL" -le 25 ];  then ICON=$(printf '\udb82\udd1f')  # weak
    elif [ "$SIGNAL" -le 50 ];  then ICON=$(printf '\udb82\udd22')  # same icon, could pick different
    elif [ "$SIGNAL" -le 75 ];  then ICON=$(printf '\udb82\udd25')
    else                             ICON=$(printf '\udb82\udd28')

    echo "<txt>${ICON}</txt>"
    ;;

  sound)
    # Example using pamixer; adjust to your stack
    VOL=$(pamixer --get-volume 2>/dev/null || echo 0)
    MUTED=$(pamixer --get-mute 2>/dev/null || echo "false")

    if [ "$MUTED" = "true" ] || [ "$VOL" -eq 0 ]; then
      ICON=$(printf '\uf026')     # nf-fa-volume_off
    elif [ "$VOL" -le 33 ]; then
      ICON=$(printf '\uf027')     # nf-fa-volume_down
    else
      ICON=$(printf '\uf028')     # nf-fa-volume_up
    fi

    echo "<txt>${ICON}</txt>"
    ;;

  *)
    echo "<txt>?</txt>"
    ;;
esac