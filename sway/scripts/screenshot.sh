#!/bin/sh
# screenshot.sh — chụp màn hình sway
# Cách dùng: screenshot.sh [full|area]  (mặc định: area)
#  - full : chụp toàn màn hình
#  - area : chọn vùng bằng chuột (slurp)

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/shot-$(date +%Y%m%d-%H%M%S).png"

if [ "${1:-area}" = "full" ]; then
    grim "$FILE" || exit 1
else
    # Slurp trả về lỗi nếu user bấm Esc → thoát im lặng
    GEOM="$(slurp)" || exit 0
    grim -g "$GEOM" "$FILE" || exit 1
fi

# Clip ảnh vào clipboard cho tiện dán
wl-copy < "$FILE"
notify-send "Screenshot" "Đã lưu $FILE (đã copy vào clipboard)" -i "$FILE"
