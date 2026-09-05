#!/bin/sh
# clipboard.sh — lịch sử clipboard (cliphist + fuzzel)
# Cần wl-paste --watch cliphist store đang chạy (có sẵn trong sway config)

IMW="$HOME/.config/sway/scripts/fuzzel-wrap.sh"
SELECTION="$(cliphist list | "$IMW" --dmenu --prompt="Clipboard: ")"
[ -n "$SELECTION" ] || exit 0

printf "%s" "$SELECTION" | cliphist decode | wl-copy
