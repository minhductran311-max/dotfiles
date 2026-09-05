#!/bin/sh
# launcher.sh - Mod+D: mo wofi drun; co wofi khac dang mo lau hon 1s -> dong va mo thay
# Bam lien tuc nhanh hon 1s -> bo qua -> khong bao gio mo nhieu cua so dai nhau

OLDEST=$(pgrep -x wofi | head -n1)
if [ -n "$OLDEST" ]; then
    NOW=$(date +%s)
    START=$(stat -c %Y "/proc/$OLDEST" 2>/dev/null || echo "$NOW")
    AGE=$((NOW - START))
    if [ "$AGE" -lt 1 ]; then
        exit 0
    fi
    pkill -x wofi 2>/dev/null
    sleep 0.2
fi
exec wofi --show drun
