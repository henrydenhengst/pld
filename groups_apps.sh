#!/bin/bash
set -e

# 1. Systeem Update & Core Tools
if command -v pacman &> /dev/null; then INSTALL="sudo pacman -S --noconfirm"; FLAT="flatpak"
elif command -v dnf &> /dev/null; then INSTALL="sudo dnf install -y"; FLAT="flatpak"
elif command -v apt-get &> /dev/null; then INSTALL="sudo apt-get install -y"; FLAT="flatpak"
fi

$INSTALL micro vim kitty eza bat fzf btop curl git $FLAT

# 2. Flathub configureren (De standaard voor desktop apps)
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 3. Voorbeeld: De Media-Creator Stack via Flatpak (Optimaal voor GUI apps)
echo "Welke stack wil je laden?"
echo "1) DevOps  2) Media  3) Gamer  4) Office  5) Education"
read -p "Keuze: " stack_choice

case $stack_choice in
    2) flatpak install -y flathub org.kde.kdenlive com.obsproject.Studio org.blender.Blender org.gimp.GIMP org.inkscape.Inkscape ;;
    # De overige keuzes volgen dezelfde logica...
esac

echo ">>> Systeem is nu conform de 2026 standaard ingericht."
