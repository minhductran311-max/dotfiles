#!/bin/sh
# fuzzel-wrap.sh - chay fuzzel voi bo go LUON o che do EN
# Tren sway (input-method-v2) trang thai fcitx5 la GLOBAL: mo fuzzel tu terminal
# dang go tieng Viet -> fuzzel ke thua Unikey -> go "as" ra "as" dau. Wrap nay
# tat bo go truoc khi mo fuzzel, dong fuzzel thi tra lai trang thai cu.

STATEF="$XDG_RUNTIME_DIR/fuzzel-im-state"

# Ghi nho trang thai goc (chi lan dau trong chuoi; wrapper sau ke thua file nay)
if [ ! -f "$STATEF" ]; then
    fcitx5-remote 2>/dev/null > "$STATEF"
fi

# Tat bo go -> trong fuzzel go duoc EN sach se
fcitx5-remote -c >/dev/null 2>&1

fuzzel "$@"
RC=$?

# fuzzel bi wrapper khac pkill (exit >= 128) -> de wrapper do phuc hoi trang thai
if [ "$RC" -lt 128 ]; then
    WANTED=$(cat "$STATEF" 2>/dev/null)
    if [ "$WANTED" = "2" ]; then
        fcitx5-remote -o >/dev/null 2>&1
    fi
    rm -f "$STATEF"
fi
exit "$RC"
