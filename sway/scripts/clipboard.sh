#!/bin/sh
# clipboard.sh — lịch sử clipboard (cliphist + fuzzel), 1 cửa sổ duy nhất
# Cần wl-paste --watch cliphist store đang chạy (có sẵn trong sway config)
# Bấm khi fuzzel khác đang mở quá 1s -> đóng và mở menu clipboard thay thế
# Bấm liên tục nhanh hơn 1s -> bỏ qua -> không bao giờ mở nhiều cửa sổ

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

IMW="$HOME/.config/sway/scripts/fuzzel-wrap.sh"
SELECTION="$(cliphist list | "$IMW" --dmenu --prompt="Clipboard: ")"
[ -n "$SELECTION" ] || exit 0

printf "%s" "$SELECTION" | cliphist decode | wl-copy
