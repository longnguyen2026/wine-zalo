#!/usr/bin/env bash

set -e

PREFIX="$HOME/.wine-zalo"
ZALO_EXE="$PREFIX/drive_c/users/$USER/AppData/Local/Programs/Zalo/Zalo.exe"

# Kiểm tra Zalo
if [ ! -f "$ZALO_EXE" ]; then
    zenity --error \
        --title="Zalo Wine" \
        --text="Không tìm thấy Zalo.exe"
    exit 1
fi

# Chuyển bộ gõ Linux sang English
if command -v fcitx5-remote >/dev/null 2>&1; then
    fcitx5-remote -c >/dev/null 2>&1 || true
fi

if command -v ibus >/dev/null 2>&1; then
    ibus engine xkb:us::eng >/dev/null 2>&1 || true
fi

# Mở EVKey nếu có
EVKEY=$(find "$PREFIX/drive_c" -type f -iname "EVKey*.exe" | head -n1)

if [ -n "$EVKEY" ]; then
    env WINEPREFIX="$PREFIX" wine "$EVKEY" >/dev/null 2>&1 &
    sleep 2
fi

# Mở UniKey nếu có (nếu chưa có EVKey)
if [ -z "$EVKEY" ]; then
    UNIKEY=$(find "$PREFIX/drive_c" -type f -iname "UniKey*.exe" | head -n1)

    if [ -n "$UNIKEY" ]; then
        env WINEPREFIX="$PREFIX" wine "$UNIKEY" >/dev/null 2>&1 &
        sleep 2
    fi
fi

# Mở Zalo
env WINEPREFIX="$PREFIX" wine "$ZALO_EXE"

# Đóng EVKey
pkill -f "EVKey.*\.exe" 2>/dev/null || true

# Đóng UniKey
pkill -f "UniKey.*\.exe" 2>/dev/null || true

# Bật lại bộ gõ Linux
if command -v fcitx5-remote >/dev/null 2>&1; then
    fcitx5-remote -o >/dev/null 2>&1 || true
fi

exit 0
