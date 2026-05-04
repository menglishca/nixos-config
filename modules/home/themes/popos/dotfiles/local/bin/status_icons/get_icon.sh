#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  battery)
    # grep -q only sets exit status, so test it directly
    if ls /sys/class/power_supply 2>/dev/null | grep -qE 'BAT|battery'; then
      "$HOME/.local/bin/status_icons/battery.sh"
    else
      echo -e "<txt></txt>\n<tool></tool>"
      exit 0
    fi
    ;;

  wifi)
    wifi_device_identifier=$(
      nmcli -t -f DEVICE,TYPE dev | awk -F: '$2=="wifi"{print $1; exit}' || true
    )
    if [[ -n "${wifi_device_identifier}" ]]; then
      "$HOME/.local/bin/status_icons/wifi.sh" "${wifi_device_identifier}"
    else 
      echo -e "<txt></txt>\n<tool></tool>"
      exit 0
    fi
    ;;

  sound)
    VOL=$(pamixer --get-volume 2>/dev/null || echo 0)
    MUTED=$(pamixer --get-mute 2>/dev/null || echo "false")
    echo "Volume: ${VOL}%, Muted: ${MUTED}" > /tmp/volume_status

    if [ "$MUTED" = "true" ] || [ "$VOL" -eq 0 ]; then
      ICON=$(printf '\uf026')
    elif [ "$VOL" -le 33 ]; then
      ICON=$(printf '\uf027')
    else
      ICON=$(printf '\uf028')
    fi

    ~/.local/bin/status_icons/build_icon.sh --segment "${ICON}"
    ;;
  power)
    ICON=$(printf '\U000F0425')
    ~/.local/bin/status_icons/build_icon.sh --segment "${ICON}"
    ;;
  *)
    echo "<txt>${1:-}</txt>"
    ;;
esac