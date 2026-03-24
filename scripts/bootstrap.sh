#!/bin/bash

# =================================================================
# PLD CLIENT BOOTSTRAP SCRIPT (Sluis-Model v2)
# Gebruik: curl -s http://192.168.100.1/bootstrap.sh | bash
# Of met profiel: curl -s http://192.168.100.1/bootstrap.sh | bash -s 2
# =================================================================

set -e

# 1. Variabelen & Omgeving
GATEWAY_IP="192.168.100.1"
PROFIEL=$1  # Kan leeg zijn voor de interactieve Selector
REPO_URL="https://github.com/henrydenhengst/pld.git" # De bron van waarheid

echo "--- 🚀 PLD Bootstrap Sluis-Model gestart ---"

# 2. Netwerk & Sluis Check
if ! ping -c 1 -W 2 $GATEWAY_IP &> /dev/null; then
    echo "❌ FOUT: PLD-moederschip ($GATEWAY_IP) onbereikbaar. Check je kabel/switch!"
    exit 1
fi

# 3. Injecteer Apt-Proxy (Cruciaal voor snelheid in de straat)
echo "Stap 1: Apt-Proxy configureren via de Sluis..."
echo "Acquire::http::Proxy \"http://$GATEWAY_IP:3142\";" | sudo tee /etc/apt/apt.conf.d/01proxy

# 4. Voorbereiden Lokale Machine
echo "Stap 2: Systeem updaten en Ansible installeren..."
sudo apt update -y
sudo apt install -y ansible git python3-pip

# 5. Configuraties ophalen
echo "Stap 3: PLD-Architectuur binnenhalen..."
rm -rf /tmp/pld-config
git clone --depth 1 $REPO_URL /tmp/pld-config

# 6. Uitvoeren van de installatie
cd /tmp/pld-config

if [ -z "$PROFIEL" ]; then
    echo "Stap 4: Starten interactieve selector..."
    sudo ansible-playbook -i "localhost," -c local playbooks/desktop.yml
else
    echo "Stap 4: Starten automatische installatie (Profiel: $PROFIEL)..."
    sudo ansible-playbook -i "localhost," -c local playbooks/desktop.yml --extra-vars "pld_profile=$PROFIEL"
fi

# 7. Afronding
echo "--- ✅ PLD Installatie Voltooid! ---"
echo "Logbestand in /var/log/pld-install.log (indien geconfigureerd)"
echo "Het systeem is nu gehard en geconfigureerd. Herstarten wordt aanbevolen."
