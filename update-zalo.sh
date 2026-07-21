#!/usr/bin/env bash
#
# Zalo Updater for Linux Mint
# Author: LongNguyen2026
#

set -e

PREFIX="$HOME/.wine-zalo"
ZALO="$HOME/Downloads/ZaloSetup.exe"

export WINEPREFIX="$PREFIX"

if [ ! -d "$PREFIX" ]; then
    zenity --error \
    --title="Zalo Updater" \
    --text="Chưa tìm thấy Zalo.\nHãy chạy install-zalo.sh trước."
    exit 1
fi

if [ ! -f "$ZALO" ]; then
    zenity --error \
    --title="Zalo Updater" \
    --text="Không tìm thấy:\n$ZALO"
    exit 1
fi

zenity --info \
--title="Zalo Updater" \
--text="Bộ cài Zalo sẽ được mở để nâng cấp.\nChỉ cần làm theo hướng dẫn trên màn hình."

wine "$ZALO"

zenity --info \
--title="Zalo Updater" \
--text="Đã hoàn tất quá trình nâng cấp Zalo."

echo "Done."
