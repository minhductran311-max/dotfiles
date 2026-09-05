#!/bin/sh
# Super+/ — cheat sheet keybindings phan nhom, chu thich tieng Viet
IMW="$HOME/.config/sway/scripts/fuzzel-wrap.sh"
cat <<EOF | "$IMW" --dmenu --prompt="Keybinds: " 2>/dev/null
─────────── ỨNG DỤNG ───────────
Super+Enter          Mở terminal (foot)
Super+D              Mở launcher ứng dụng (fuzzel)
Super+B              Mở trình duyệt Thorium
Super+N              Quản lý wifi / mạng
Super+M              Quản lý bluetooth (ghép đôi tai nghe...)
Super+C              Lịch sử clipboard — chọn mục để copy lại
Super+/              Bảng phím tắt này
─────────── CỬA SỔ ───────────
Super+Q              Đóng cửa sổ đang chọn
Super+F              Bật/tắt toàn màn hình
Super+Shift+Space    Bật/tắt chế độ nổi (floating)
Super+Space          Nhảy giữa window nổi và window thường
Giữ Super + kéo      Rê window (tự nổi khi kéo)
Super+A              Focus lên nhóm window cha
─────────── FOCUS (kiểu vim) ───────────
Super+H  hoặc ←      Focus sang trái
Super+J  hoặc ↓      Focus xuống dưới
Super+K  hoặc ↑      Focus lên trên
Super+L  hoặc →      Focus sang phải
─────────── DI CHUYỂN WINDOW ───────────
Super+Shift+H/J/K/L  Dời window trái/xuống/lên/phải
Super+Shift+1..0     Đưa window sang workspace 1-10
─────────── LAYOUT ───────────
Super+Shift+B        Chia ngang (window mới mở sang phải)
Super+V              Chia dọc (window mới mở xuống dưới)
Super+E              Đảo hướng chia ngang/dọc
Super+S              Xếp chồng (stacking)
Super+W              Xếp thẻ (tabbed)
(Cụm này ít dùng — autotiling đang tự chia giúp bạn)
─────────── WORKSPACE ───────────
Super+1 .. Super+0   Chuyển sang workspace 1-10
─────────── ẢNH CHỤP & CLIPBOARD ───────────
Print                Chụp toàn màn hình
Shift+Print          Chụp vùng chọn (kéo chuột bao vùng)
─────────── PHIÊN LÀM VIỆC ───────────
Super+Shift+C        Reload lại config Sway
Super+Shift+X        Khoá màn hình (swaylock blur)
Super+Shift+E        Thoát Sway — hiện hộp xác nhận
─────────── ÂM THANH & ĐỘ SÁNG ───────────
Phím Volume          Tăng/giảm/tắt tiếng (bước 5%)
Phím Brightness      Tăng/giảm độ sáng màn hình (bước 5%)
─────────── HAI CHẾ ĐỘ TẠM THỜI ───────────
Super+R  resize      Rồi bấm H/J/K/L để co-giãn window, Enter/Esc thoát
Super+G  gaps        Rồi bấm + / - / 0 để chỉnh gaps, Enter/Esc thoát
(Gõ để tìm kiếm — Esc để đóng bảng này)
EOF
