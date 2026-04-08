#!/usr/bin/env bash

role="$1"

case "$role" in
  battery)
    icon=""
    ;;
  wifi)
    icon=""
    ;;
  sound)
    icon=""
    ;;
  power)
    icon="⏻"
    ;;
  *)
    icon="?"
    ;;
esac

echo "${icon}"