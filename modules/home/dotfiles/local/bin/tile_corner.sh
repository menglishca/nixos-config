#!/bin/sh
# Corner tiling script
CORNER="$1"

# Get screen dimensions
SCREEN=$(wmctrl -d | grep '*' | awk '{print $4}')
WIDTH=$(echo "$SCREEN" | cut -d'x' -f1)
HEIGHT=$(echo "$SCREEN" | cut -d'x' -f2)

# Quarter-screen dimensions
QW=$((WIDTH / 2))
QH=$((HEIGHT / 2))

case "$CORNER" in
    top-left)
        wmctrl -r :ACTIVE: -e 0,0,0,$QW,$QH
        ;;
    top-right)
        wmctrl -r :ACTIVE: -e 0,$((WIDTH - QW)),0,$QW,$QH
        ;;
    bottom-left)
        wmctrl -r :ACTIVE: -e 0,0,$((HEIGHT - QH)),$QW,$QH
    ;;
    bottom-right)
        wmctrl -r :ACTIVE: -e 0,$((WIDTH - QW)),$((HEIGHT - QH)),$QW,$QH
        ;;
    top)
        wmctrl -r :ACTIVE: -e 0,0,0,$WIDTH,$QH
        ;;
    bottom)
        wmctrl -r :ACTIVE: -e 0,0,$((HEIGHT - QH)),$WIDTH,$QH
        ;;
    left)
        wmctrl -r :ACTIVE: -e 0,0,0,$QW,$HEIGHT
        ;;
    right)
        wmctrl -r :ACTIVE: -e 0,$((WIDTH - QW)),0,$QW,$HEIGHT
        ;;
esac