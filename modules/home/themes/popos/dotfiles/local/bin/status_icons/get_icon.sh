#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  battery)
    # grep -q only sets exit status, so test it directly
    if ls /sys/class/power_supply 2>/dev/null | grep -qE 'BAT|battery'; then
      "$HOME/.local/bin/status_icons/battery.sh"
    else
      exit 0;
    fi
    ;;

  wifi)
    wifi_device_identifier=$(
      nmcli -t -f DEVICE,TYPE dev | awk -F: '$2=="wifi"{print $1; exit}' || true
    )
    if [[ -n "${wifi_device_identifier}" ]]; then
      "$HOME/.local/bin/status_icons/wifi.sh" "${wifi_device_identifier}"
    else 
      exit 0;
    fi
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
    echo "<txt>${1:-}</txt>"
    ;;
esac