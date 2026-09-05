#!/bin/sh
# launcher.sh - Mod+D: mo fuzzel; co fuzzel khac dang mo lau hon 1s -> dong va mo thay
# Bam lien tuc nhanh hon 1s -> bo qua -> khong bao gio mo nhieu cua so dai nhau

OLDEST=$(pgrep -x fuzzel | head -n1)
if [ -n "$OLDEST" ]; then
    NOW=$(date +%s)
    START=$(stat -c %Y "/proc/$OLDEST" 2>/dev/null || echo "$NOW")
    AGE=$((NOW - START))
    if [ "$AGE" -lt 1 ]; then
        exit 0
    fi
    pkill -x fuzzel 2>/dev/null
    sleep 0.2
fi
exec "$HOME/.config/sway/scripts/fuzzel-wrap.sh"
