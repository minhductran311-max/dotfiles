#!/bin/sh
# launcher.sh - Mod+D: mo wofi; bam lan nua khi dang mo lau hon 1s -> dong (toggle)
# Bam lien tuc nhanh hon 1s se duoc bo qua -> khong bao gio mo nhieu cua so dai nhau

OLDEST=$(pgrep -x wofi | head -n1)
if [ -n "$OLDEST" ]; then
    NOW=$(date +%s)
    START=$(stat -c %Y "/proc/$OLDEST" 2>/dev/null || echo "$NOW")
    AGE=$((NOW - START))
    if [ "$AGE" -ge 1 ]; then
        pkill -x wofi 2>/dev/null
    fi
    exit 0
fi
exec wofi --show drun
