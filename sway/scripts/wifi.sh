#!/bin/sh
# wifi.sh - menu chon wifi bang wofi + nmcli (goi tu Mod+N)
# Chon mang de ket noi. Mang khoa se hoi mat khau.
# Bam vao mang dang ket noi -> ngat ket noi.

say() {
    notify-send "WiFi" "$1" 2>/dev/null || echo "$1"
}

# Tim card wifi (wlan0 / wlp2s0 ...)
DEV=$(nmcli -t -f DEVICE,TYPE device status 2>/dev/null | awk -F: "\$2==\"wifi\"{print \$1; exit}")
if [ -z "$DEV" ]; then
    say "Khong tim thay card wifi - kiem tra nmcli / NetworkManager"
    exit 1
fi

# Quet va liet ke mang: SSID + cuong song (%)
SCAN=$(nmcli -f IN-USE,SSID,SIGNAL dev wifi list --rescan yes 2>/dev/null | tail -n +2)
CHOICE=$(printf "%s\n" "$SCAN" | awk "{ sig=\$NF; \$NF=\"\"; ssid=\$0; gsub(/^ +| +\$/, \"\", ssid); if (ssid!=\"\" && ssid!=\"*\") printf \"%03d %s  %s%%\n\", sig, ssid, sig }" | sort -r | uniq | sed "s/^[0-9]* //" | wofi --dmenu --insensitive --prompt "WiFi" --width 500)
[ -z "$CHOICE" ] && exit 0

SSID=${CHOICE%  *}
SSID=$(printf "%s" "$SSID" | sed "s/^\* *//")

# Bam vao mang dang ket noi -> ngat
ACTIVE=$(nmcli -t -f NAME,TYPE connection show --active 2>/dev/null | awk -F: "\$2==\"802-11-wireless\"{print \$1}")
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
