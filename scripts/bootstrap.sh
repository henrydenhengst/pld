#!/bin/bash

# =================================================================
# PLD CLIENT BOOTSTRAP SCRIPT
# Gebruik: curl -s http://192.168.100.1/bootstrap.sh | bash -s [profiel]
# =================================================================

set -e

# 1. Variabelen & Argumenten
GATEWAY_IP="192.168.100.1"
PROFIEL=${1:-office} # Standaard naar 'office' als er geen argument is

echo "--- 🚀 PLD Bootstrap gestart (Profiel: $PROFIEL) ---"

# 2. Netwerk Check
if ! ping -c 1 $GATEWAY_IP &> /dev/null; then
    echo "❌ FOUT: Kan de PLD-server ($GATEWAY_IP) niet bereiken."
    exit 1
fi

# 3. Configureer Apt-Proxy (Voor de snelheid)
echo "Stap 1: Apt-Proxy instellen via de sluis..."
echo "Acquire::http::Proxy \"http://$GATEWAY_IP:3142\";" | sudo tee /etc/apt/apt.conf.d/01proxy

# 4. Installeer Ansible op de Client
echo "Stap 2: Lokale tools installeren..."
sudo apt update
sudo apt install -y ansible git

# 5. Haal de volledige configuratie op van de server
echo "Stap 3: Git-repo binnenhalen voor lokale uitvoering..."
rm -rf ~/pld-config
git clone http://$GATEWAY_IP/pld.git ~/pld-config

# 6. Voer de Ansible-magie uit op basis van het gekozen profiel
echo "Stap 4: Ansible Playbook starten voor profiel: $PROFIEL..."
cd ~/pld-config
sudo ansible-playbook -i "localhost," -c local playbooks/desktop.yml --extra-vars "pld_profile=$PROFIEL"

echo "--- ✅ PLD Installatie Voltooid! ---"
echo "Herstart de machine om alle wijzigingen te activeren."
