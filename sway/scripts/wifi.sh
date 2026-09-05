#!/bin/sh
# wifi.sh - Mod+N: menu wifi wofi (1 cua so duy nhat + hien tu cache cho nhanh)
# Bam khi wofi khac dang mo lau hon 1s -> dong cua cu, mo menu wifi thay the
# Bam lien tuc nhanh hon 1s -> bo qua -> khong bao gio mo nhieu cua so

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

say() {
    notify-send "WiFi" "$1" 2>/dev/null || echo "$1"
}

# Quet ngam cho lan mo sau (khong cho)
nmcli device wifi rescan >/dev/null 2>&1 &

# Danh sach mang tu cache: SSID + cuong song (%)
SCAN=$(nmcli -f IN-USE,SSID,SIGNAL dev wifi list 2>/dev/null | tail -n +2)
if [ -z "$SCAN" ]; then
    say "Khong thay mang nao - kiem tra NetworkManager / card wifi"
    exit 0
fi

CHOICE=$(printf "%s\n" "$SCAN" | awk "{ sig=\$NF; \$NF=\"\"; ssid=\$0; gsub(/^ +| +\$/, \"\", ssid); if (ssid!=\"\" && ssid!=\"*\") printf \"%03d %s  %s%%\n\", sig, ssid, sig }" | sort -r | uniq | sed "s/^[0-9]* //" | wofi --dmenu --insensitive --prompt "WiFi" --width 500)
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

# Mang khoa ma chua co mat khau -> hoi bang wofi
if printf "%s" "$OUT" | grep -qi "secrets\|password"; then
    PW=$(wofi --dmenu --password --prompt "Mat khau $SSID")
    [ -z "$PW" ] && exit 0
    OUT=$(nmcli device wifi connect "$SSID" password "$PW" 2>&1)
fi

if printf "%s" "$OUT" | grep -qi "successfully\|activated"; then
    say "Da ket noi: $SSID"
else
    say "Ket noi that bai: $OUT"
fi
