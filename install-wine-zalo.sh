#!/usr/bin/env bash
#
# Zalo Wine Installer for Linux Mint
# Author: LongNguyen2026
# Downloads ~/Downloads/ZaloSetup.exe
#

set -e

PREFIX="$HOME/.wine-zalo"
ZALO_EXE="$HOME/Downloads/ZaloSetup.exe"

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
NC="\033[0m"

echo -e "${BLUE}"
echo "==============================================="
echo "        ZALO WINE INSTALLER"
echo "==============================================="
echo -e "${NC}"

echo -e "${YELLOW}Updating package list...${NC}"
sudo apt update

echo -e "${YELLOW}Enable i386 architecture...${NC}"
sudo dpkg --add-architecture i386

echo -e "${YELLOW}Installing WineHQ repository...${NC}"

sudo mkdir -pm755 /etc/apt/keyrings

if [ ! -f /etc/apt/keyrings/winehq-archive.key ]; then
    sudo wget -q -O /etc/apt/keyrings/winehq-archive.key \
    https://dl.winehq.org/wine-builds/winehq.key
fi

if [ ! -f /etc/apt/sources.list.d/winehq-noble.sources ]; then
    sudo wget -q -O /etc/apt/sources.list.d/winehq-noble.sources \
    https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources
fi

sudo apt update

echo -e "${YELLOW}Installing WineHQ Stable...${NC}"

sudo apt install -y --install-recommends \
winehq-stable \
winetricks \
zenity \
cabextract \
wget \
curl \
unzip

echo -e "${YELLOW}Checking installer...${NC}"

if [ ! -f "$ZALO_EXE" ]; then
    zenity --error \
    --title="Installer not found" \
    --text="Không tìm thấy:\n\n$ZALO_EXE"
    exit 1
fi

echo -e "${YELLOW}Creating Wine Prefix...${NC}"

export WINEPREFIX="$PREFIX"
export WINEARCH=win64

if [ ! -d "$PREFIX" ]; then
    wineboot -u
fi

echo -e "${YELLOW}Configuring Windows 10...${NC}"
winetricks -q win10

echo -e "${YELLOW}Installing runtime libraries...${NC}"

winetricks -q \
corefonts \
gdiplus \
riched20 \
msxml6 \
vcrun2022

echo -e "${YELLOW}Starting Zalo installer...${NC}"

wine "$ZALO_EXE"

echo -e "${YELLOW}Searching for Zalo.exe...${NC}"

ZALO_BIN=$(find "$PREFIX/drive_c" -iname "Zalo.exe" 2>/dev/null | head -n1)

if [ -n "$ZALO_BIN" ]; then

mkdir -p "$HOME/Desktop"

cat > "$HOME/Desktop/Zalo.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Zalo
Exec=env WINEPREFIX=$PREFIX wine "$ZALO_BIN"
Icon=wine
Terminal=false
Categories=Network;
EOF

chmod +x "$HOME/Desktop/Zalo.desktop"

echo -e "${GREEN}Desktop shortcut created.${NC}"

else

echo -e "${RED}Không tìm thấy Zalo.exe sau khi cài.${NC}"
echo "Nếu Zalo cài ở thư mục khác, hãy sửa shortcut sau."

fi

echo
echo -e "${GREEN}==============================================="
echo "Finished"
echo "Wine Prefix : $PREFIX"
echo "Installer   : $ZALO_EXE"
echo "==============================================="
echo -e "${NC}"
