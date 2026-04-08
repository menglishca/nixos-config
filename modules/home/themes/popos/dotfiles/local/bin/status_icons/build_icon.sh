#!/usr/bin/env bash
set -euo pipefail

# Usage:
# build-icon.sh [--pill COLOR] [--padding PX] \
#   [--segment TEXT [--color COLOR] [--bold]] ...

PILL_COLOR=""
PADDING=""   # only used if PILL_COLOR is set
SEGMENTS=()

while [ $# -gt 0 ]; do
    case "$1" in
        --pill)
            PILL_COLOR="$2"
            shift 2
            ;;
        --padding)
            PADDING="$2"
            shift 2
            ;;
        --segment)
            TEXT="$2"; COLOR=""; BOLD=0
            shift 2
            while [ $# -gt 0 ]; do
                case "$1" in
                    --color)
                        COLOR="$2"; shift 2 ;;
                    --bold)
                        BOLD=1; shift ;;
                    --segment|--pill|--padding)
                        break ;;
                    *)
                        echo "Unknown arg: $1" >&2
                        exit 1 ;;
                esac
            done

            if [ -n "$COLOR" ] ; then
                SEGMENT="<span foreground=\"${COLOR}\">${TEXT}</span>";
            elif [ "$BOLD" -eq 1 ]; then
                SEGMENT="<b>${TEXT}</b>";
            else
                SEGMENT="$TEXT";
            fi

            SEGMENTS+=("$SEGMENT")
            ;;
        *)
            echo "Unknown arg: $1" >&2
            exit 1 ;;
    esac
done

CONTENT="${SEGMENTS[*]}"

echo "<txt>${CONTENT}</txt>"

if [ -n "$PILL_COLOR" ]; then
    # Default padding = 10 if pill is used and padding not specified
    [ -z "$PADDING" ] && PADDING=10
    cat <<EOF
        <css>.genmon_valuebutton {
            background-color: ${PILL_COLOR};
            padding-left: ${PADDING}px;
            padding-right: ${PADDING}px;
            font-weight: bold;
        }</css>
    EOF
fi