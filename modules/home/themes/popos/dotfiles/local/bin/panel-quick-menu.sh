#!/usr/bin/env bash
mode="$1"

case "$mode" in
  battery) prompt="Battery" ;;
  wifi)    prompt="Wi-Fi" ;;
  sound)   prompt="Sound" ;;
  power|"")   prompt="Power" ;;
esac

choice=$(printf '%s\n' "Not implemented yet" | rofi -dmenu -p "$prompt")
