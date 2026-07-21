#!/usr/bin/env bash
#
# Zalo Installer for Linux Mint
# Author: LongNguyen2026
#

set -e

PREFIX="$HOME/.wine-zalo"
ZALO="$HOME/Downloads/ZaloSetup.exe"

GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m"

echo -e "${BLUE}"
echo "========================================="
echo "      ZALO INSTALLER v2.1"
echo "========================================="
echo -e "${NC}"

echo -e "${YELLOW}>> Updating packages...${NC}"
sudo apt update

echo -e "${YELLOW}>> Enable i386...${NC}"
sudo dpkg --add-architecture i386

sudo mkdir -p /etc/apt/keyrings

if [ ! -f /etc/apt/keyrings/winehq-archive.key ]; then
    sudo wget -q -O /etc/apt/keyrings/winehq-archive.key \
    https://dl.winehq.org/wine-builds/winehq.key
fi

if [ ! -f /etc/apt/sources.list.d/winehq-noble.sources ]; then
    sudo wget -q -O /etc/apt/sources.list.d/winehq-noble.sources \
    https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources
fi

sudo apt update

echo -e "${YELLOW}>> Installing WineHQ Stable...${NC}"

sudo apt install -y --install-recommends \
winehq-stable \
winetricks \
cabextract \
zenity \
wget \
curl \
unzip

if [ ! -f "$ZALO" ]; then
    zenity --error \
    --title="Zalo Installer" \
    --text="Không tìm thấy:\n$ZALO"
    exit 1
fi

echo -e "${YELLOW}>> Creating Wine Prefix...${NC}"

export WINEPREFIX="$PREFIX"
export WINEARCH=win64

if [ ! -d "$PREFIX" ]; then
    wineboot -u
fi

echo -e "${YELLOW}>> Setting Windows 10...${NC}"
winetricks -q win10

echo -e "${YELLOW}>> Installing Core Fonts...${NC}"
winetricks -q corefonts

echo -e "${YELLOW}>> Running Zalo Installer...${NC}"
wine "$ZALO"

echo
echo "Searching Zalo.exe..."

ZALO_EXE=$(find "$PREFIX/drive_c" -iname "Zalo.exe" | head -n1)

if [ -n "$ZALO_EXE" ]; then

mkdir -p "$HOME/Desktop"

cat > "$HOME/Desktop/Zalo.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Zalo
Exec=env WINEPREFIX=$PREFIX wine "$ZALO_EXE"
Icon=wine
Terminal=false
Categories=Network;
EOF

chmod +x "$HOME/Desktop/Zalo.desktop"

echo -e "${GREEN}Shortcut created on Desktop.${NC}"

else

echo -e "${RED}Không tìm thấy Zalo.exe.${NC}"
echo "Có thể Zalo chưa cài xong."

fi

echo
echo -e "${GREEN}DONE!${NC}"
