#!/bin/sh
# wifi.sh - Mod+N: menu wifi fuzzel (1 cua so duy nhat + danh sach tu cache: mo tuc thi)
# Bam khi fuzzel khac dang mo lau hon 1s -> dong cua cu, mo menu wifi thay the
# Bam lien tuc nhanh hon 1s -> bo qua -> khong bao gio mo nhieu cua so

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

say() {
    notify-send "WiFi" "$1" 2>/dev/null || echo "$1"
}

CACHE="$HOME/.cache/wifi-menu.txt"
TMPF="$HOME/.cache/wifi-menu.tmp"
IMW="$HOME/.config/sway/scripts/fuzzel-wrap.sh"

# Quet ngam cap nhat cache cho lan mo sau (khong bao gio cho)
(nmcli device wifi rescan >/dev/null 2>&1; sleep 3; nmcli -f IN-USE,SSID,SIGNAL dev wifi list 2>/dev/null | tail -n +2 > "$TMPF"; if [ -s "$TMPF" ]; then mv "$TMPF" "$CACHE"; fi) &

# Danh sach mang: doc cache (tuc thi); lan dau chua co cache -> quet dong bo 1 lan roi luu
SCAN=$(cat "$CACHE" 2>/dev/null)
if [ -z "$SCAN" ]; then
    SCAN=$(nmcli -f IN-USE,SSID,SIGNAL dev wifi list 2>/dev/null | tail -n +2)
    if [ -n "$SCAN" ]; then
        printf "%s\n" "$SCAN" > "$CACHE"
    fi
fi
if [ -z "$SCAN" ]; then
    say "Khong thay mang nao - kiem tra NetworkManager / card wifi"
    exit 0
fi

CHOICE=$(printf "%s\n" "$SCAN" | awk "{ sig=\$NF; \$NF=\"\"; ssid=\$0; gsub(/^ +| +\$/, \"\", ssid); if (ssid!=\"\" && ssid!=\"*\") printf \"%03d %s  %s%%\n\", sig, ssid, sig }" | sort -r | uniq | sed "s/^[0-9]* //" | "$IMW" --dmenu --prompt="WiFi: ")
[ -z "$CHOICE" ] && exit 0

SSID=${CHOICE%  *}
SSID=$(printf "%s" "$SSID" | sed "s/^\* *//")

ACTIVE=$(nmcli -t -f NAME,TYPE connection show --active 2>/dev/null | awk -F: "\$2==\"802-11-wireless\"{print \$1}")
DEV=$(nmcli -t -f DEVICE,TYPE device status 2>/dev/null | awk -F: "\$2==\"wifi\"{print \$1; exit}")

# Bam vao mang dang ket noi -> ngat
if [ "$ACTIVE" = "$SSID" ]; then
    nmcli device disconnect "$DEV" >/dev/null 2>&1
    say "Da ngat ket noi: $SSID"
    exit 0
fi

# Thu ket noi (dung mat khau da luu neu co)
OUT=$(nmcli device wifi connect "$SSID" 2>&1)

# Mang khoa ma chua co mat khau -> hoi bang fuzzel (ky tu che dau *)
if printf "%s" "$OUT" | grep -qi "secrets\|password"; then
    PW=$("$IMW" --dmenu --password --prompt="Mat khau $SSID: " </dev/null)
    [ -z "$PW" ] && exit 0
    OUT=$(nmcli device wifi connect "$SSID" password "$PW" 2>&1)
fi

if printf "%s" "$OUT" | grep -qi "successfully\|activated"; then
    say "Da ket noi: $SSID"
else
    say "Ket noi that bai: $OUT"
fi
