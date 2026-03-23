#!/bin/bash
set -e

# 1. Core Installatie
echo ">>> Installeren Core DevOps Tools..."
if command -v pacman &> /dev/null; then INSTALL="sudo pacman -S --noconfirm"
elif command -v dnf &> /dev/null; then INSTALL="sudo dnf install -y"
else INSTALL="sudo apt-get install -y"; fi

$INSTALL micro vim kitty eza bat fzf btop curl git flatpak unzip

# 2. Silent Boot Config
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 systemd.show_status=auto"/' /etc/default/grub
command -v update-grub && sudo update-grub || sudo grub-mkconfig -o /boot/grub/grub.cfg

# 3. Keuzemenu voor Stacks
echo "Welke extra's wil je installeren?"
echo "1) AI (Lokale Copilot / Llama3)"
echo "2) Media (Kdenlive, OBS, Blender)"
echo "3) Gamer (Steam, Discord, Proton)"
echo "4) Office (LibreOffice, Slack, Zoom)"
read -p "Voer nummers in (bijv. 1 2): " choices

for choice in $choices; do
    case $choice in
        1) echo ">>> AI Stack laden..."; curl -fsSL https://ollama.com/install.sh | sh && ollama pull llama3 ;;
        2) echo ">>> Media Stack laden..."; sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub org.kde.kdenlive com.obsproject.Studio org.blender.Blender org.gimp.GIMP ;;
        3) echo ">>> Gamer Stack laden..."; flatpak install -y flathub com.discordapp.Discord com.heroicgamelauncher.hgl ;;
        4) echo ">>> Office Stack laden..."; flatpak install -y flathub com.slack.Slack us.zoom.Zoom com.nextcloud.desktopclient.nextcloud ;;
    esac
done

# 4. Nord & Shell Aliassen
mkdir -p ~/.config/kitty
echo -e "font_family JetBrainsMono Nerd Font\nfont_size 11.0\nbackground #2e3440" > ~/.config/kitty/kitty.conf
SHELL_RC=".$CURRENT_SHELL"rc
echo -e "\nalias ai='ollama run llama3'\nalias ls='eza --icons'\nexport EDITOR='micro'" >> ~/$SHELL_RC

echo ">>> SETUP VOLTOOID. Type 'ai' om je lokale assistent te starten."
