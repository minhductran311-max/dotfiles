#!/bin/sh
# fuzzel-wrap.sh v2 - fuzzel LUON go EN, bat chap bo go dang o che do nao
# Loi cua v1: -c chay truoc khi mo fuzzel nen chi tat bo go o window cu
# (terminal), con fuzzel mo ra la input context moi van active -> van go
# duoc tieng Viet. v2: giu -c ban dau (phung hop trang thai global) cong
# them vong lap nen SAU khi fuzzel focus: moi 0.15s tat bo go 1 lan trong
# ~1.2s - luc nay focus thuoc ve fuzzel nen -c chac chan trung bo go cua no.
# Fuzzel dong hoac trang thai da phuc hoi xong thi vong lap tu dung.

STATEF="$XDG_RUNTIME_DIR/fuzzel-im-state"

# Khong co fcitx5-remote -> khong co bo go de quan tam, chay fuzzel thuan
if ! command -v fcitx5-remote >/dev/null 2>&1; then
    exec fuzzel "$@"
fi

# Statefile sot lai tu lan chay cu da qua lau (hon 60s, vd bi pkill tay) -> bo
if [ -f "$STATEF" ]; then
    NOW=$(date +%s)
    FT=$(stat -c %Y "$STATEF" 2>/dev/null || echo "$NOW")
    if [ $((NOW - FT)) -gt 60 ]; then
        rm -f "$STATEF"
    fi
fi

# Ghi nho trang thai goc (chi lan dau trong chuoi; wrapper sau ke thua statefile)
if [ ! -f "$STATEF" ]; then
    fcitx5-remote 2>/dev/null > "$STATEF"
fi

# Tat ngay luc con o window cu (phuong an cho truong hop trang thai global)
fcitx5-remote -c >/dev/null 2>&1

# Nen bo go SAU KHI fuzzel focus (phuong an cho truong hop per-context)
(
    i=1
    while [ "$i" -le 8 ] && [ -f "$STATEF" ]; do
        sleep 0.15
        pgrep -x fuzzel >/dev/null 2>&1 || exit 0
        fcitx5-remote -c >/dev/null 2>&1
        i=$((i + 1))
    done
    # Het 1.2s ma fuzzel van chua EN -> canh bao de chan doan qua mako
    if pgrep -x fuzzel >/dev/null 2>&1 && [ -f "$STATEF" ]; then
        CUR=$(fcitx5-remote 2>/dev/null)
        if [ "$CUR" != "1" ]; then
            notify-send -t 5000 "fuzzel bo go" "Khong tat duoc fcitx5 - chay lenh fcitx5-remote roi bao ket qua" 2>/dev/null
        fi
    fi
) &

fuzzel "$@"
RC=$?

# fuzzel bi wrapper khac pkill (exit >= 128) -> wrapper sau se phuc hoi trang thai
if [ "$RC" -lt 128 ]; then
    wait
    WANTED=$(cat "$STATEF" 2>/dev/null)
    if [ "$WANTED" = "2" ]; then
        fcitx5-remote -o >/dev/null 2>&1
    fi
    rm -f "$STATEF"
fi
exit "$RC"
