#!/usr/bin/env bash
CORNER="$1"

# Get screen dimensions
SCREEN=$(wmctrl -d | grep '*' | awk '{print $4}')
SCREEN_WIDTH=$(echo "$SCREEN" | cut -d'x' -f1)
SCREEN_HEIGHT=$(echo "$SCREEN" | cut -d'x' -f2)
BOTTOM_PANEL_HEIGHT=$(wmctrl -lG | awk -v height="${SCREEN_HEIGHT}" '/xfce4-panel/ && ($4+$6) == height {print $6}')
BOTTOM_PANEL_HEIGHT=${BOTTOM_PANEL_HEIGHT:-0}
AVAILABLE_HEIGHT=$((SCREEN_HEIGHT - BOTTOM_PANEL_HEIGHT))

# Quarter-screen dimensions
HALF_SCREEN_WIDTH=$((SCREEN_WIDTH / 2))
HALF_SCREEN_HEIGHT=$((AVAILABLE_HEIGHT / 2))

case "$CORNER" in
    top-left)
        wmctrl -r :ACTIVE: -e 0,0,0,$HALF_SCREEN_WIDTH,$HALF_SCREEN_HEIGHT
        ;;
    top-right)
        wmctrl -r :ACTIVE: -e 0,$((SCREEN_WIDTH - HALF_SCREEN_WIDTH)),0,$HALF_SCREEN_WIDTH,$HALF_SCREEN_HEIGHT
        ;;
    bottom-left)
        wmctrl -r :ACTIVE: -e 0,0,$((AVAILABLE_HEIGHT - HALF_SCREEN_HEIGHT)),$HALF_SCREEN_WIDTH,$HALF_SCREEN_HEIGHT
    ;;
    bottom-right)
        wmctrl -r :ACTIVE: -e 0,$((SCREEN_WIDTH - HALF_SCREEN_WIDTH)),$((AVAILABLE_HEIGHT - HALF_SCREEN_HEIGHT)),$HALF_SCREEN_WIDTH,$HALF_SCREEN_HEIGHT
        ;;
    top)
        wmctrl -r :ACTIVE: -e 0,0,0,$SCREEN_WIDTH,$HALF_SCREEN_HEIGHT
        ;;
    bottom)
        wmctrl -r :ACTIVE: -e 0,0,$((AVAILABLE_HEIGHT - HALF_SCREEN_HEIGHT)),$SCREEN_WIDTH,$HALF_SCREEN_HEIGHT
        ;;
    left)
        wmctrl -r :ACTIVE: -e 0,0,0,$HALF_SCREEN_WIDTH,$AVAILABLE_HEIGHT
        ;;
    right)
        wmctrl -r :ACTIVE: -e 0,$((SCREEN_WIDTH - HALF_SCREEN_WIDTH)),0,$HALF_SCREEN_WIDTH,$AVAILABLE_HEIGHT
        ;;
esac