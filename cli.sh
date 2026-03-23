#!/bin/bash
set -e

echo ">>> Starten van de Universele DevOps Setup (Nord/11px)..."

# 1. Distro Detectie & Installatie van de volledige stack
if command -v pacman &> /dev/null; then
    INSTALL="sudo pacman -S --noconfirm"
    PKGS="micro vim kitty terminator eza bat fzf jq btop duf tldr kubectl terraform helm ansible-lint docker docker-compose curl git unzip"
elif command -v dnf &> /dev/null; then
    INSTALL="sudo dnf install -y"
    PKGS="micro vim kitty terminator eza bat fzf jq btop duf tldr kubectl terraform helm ansible-lint docker docker-compose-plugin curl git unzip"
elif command -v apt-get &> /dev/null; then
    INSTALL="sudo apt-get install -y"
    PKGS="micro vim kitty terminator eza bat fzf jq btop duf tldr kubectl terraform helm ansible-lint docker.io docker-compose-v2 curl git unzip"
else
    echo "Fout: Geen ondersteunde package manager gevonden (apt, dnf, pacman)."
    exit 1
fi

$INSTALL $PKGS
sudo usermod -aG docker $USER

# 2. Nerd Font Installatie (JetBrainsMono)
mkdir -p ~/.local/share/fonts
if [ ! -d "$HOME/.local/share/fonts/JetBrainsMono" ]; then
    echo ">>> Fonts installeren..."
    curl -fLo "JB.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o JB.zip -d ~/.local/share/fonts && fc-cache -f && rm JB.zip
fi

# 3. Configuratie & Nord Themes (Kitty, Terminator, Micro, Btop)
mkdir -p ~/.config/{kitty,terminator,micro,btop}

echo -e "font_family JetBrainsMono Nerd Font\nfont_size 11.0\nbackground #2e3440\nforeground #d8dee9" > ~/.config/kitty/kitty.conf

echo -e "[global_config]\n[profiles]\n  [[default]]\n    font = JetBrainsMono Nerd Font 11\n    use_system_font = False\n    background_color = '#2e3440'\n    foreground_color = '#d8dee9'" > ~/.config/terminator/config

echo '{"colorscheme": "nord", "fontsize": 11}' > ~/.config/micro/settings.json
echo 'color_theme = "nord"' > ~/.config/btop/btop.conf
echo -e "syntax on\nset number\nset mouse=a" > ~/.vimrc

# 4. Shell-Detectie & Aliassen
CURRENT_SHELL=$(basename "$SHELL")
case "$CURRENT_SHELL" in
    zsh)  CONF="$HOME/.zshrc" ;;
    fish) CONF="$HOME/.config/fish/config.fish" ;;
    *)    CONF="$HOME/.bashrc" ;;
esac

ENTRY="\n# DEVOPS MASTER BLOCK\nalias ls='eza --icons'\nalias cat='bat --theme=\"Nord\"'\nalias k='kubectl'\nalias d='docker'\nalias dc='docker compose'\nalias tf='terraform'\nalias ap='ansible-playbook'\nexport EDITOR='micro'\nexport PATH=\"\$PATH:\$HOME/.local/bin\""

if ! grep -q "DEVOPS MASTER BLOCK" "$CONF"; then
    echo -e "$ENTRY" >> "$CONF"
fi

echo ">>> Setup voltooid! Herstart je terminal voor de Nord-ervaring."
