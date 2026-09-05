#!/bin/sh
# lock.sh — khóa màn hình (swaylock-effects đọc config ~/.config/swaylock/config)
# Nếu chưa cài swaylock-effects (AUR) thì fallback về swaylock gốc

if command -v swaylock-effects >/dev/null 2>&1; then
    swaylock-effects -f
else
    swaylock -f -c 1a1b26
fi
