#!/bin/bash

# PLD Server Installatie Script
# Vereisten: Debian 11 of hoger

set -e

echo "--- Starten van PLD Server Installatie ---"

# 1. Controleer op ROOT rechten
if [ "$EUID" -ne 0 ]; then 
  echo "❌ FOUT: Voer dit script uit met sudo: sudo ./install-pld-server.sh"
  exit 1
fi

# 2. Controleer Besturingssysteem en Versie
if [ -f /etc/debian_version ]; then
    VERSION_MAJOR=$(cat /etc/debian_version | cut -d. -f1)
    if [ "$VERSION_MAJOR" -lt 11 ]; then
        echo "❌ FOUT: Dit script vereist minimaal Debian 11 (Bullseye). Je draait versie $VERSION_MAJOR."
        exit 1
    fi
    echo "✅ Besturingssysteem check: Debian $VERSION_MAJOR gedetecteerd."
else
    echo "❌ FOUT: Dit script is specifiek ontworpen voor Debian Linux."
    exit 1
fi

# 3. Installeren van NetworkManager en Ansible benodigdheden
echo "Stap 1: Installeren van NetworkManager en Ansible benodigdheden..."
apt update
apt install -y git ansible python3-pip network-manager python3-dbus

# 4. Zorg dat NetworkManager actief is
echo "Stap 2: Controleren of NetworkManager actief is..."
systemctl enable --now NetworkManager

# 5. Installeer benodigde Ansible collecties
echo "Stap 3: Ansible collecties binnenhalen..."
ansible-galaxy collection install community.general ansible.posix

# 6. Uitvoeren van het hoofd-playbook
echo "Stap 4: Starten van de Ansible configuratie..."
ansible-playbook -i "localhost," -c local playbooks/server.yml

# 7. Validatie van de nieuwe netwerk-sluis
echo "Stap 5: Controleren of de 192.168.100.1 gateway actief is..."
if ip addr show | grep -q "192.168.100.1"; then
    echo "✅ SUCCESS: De installatie-interface is actief op 192.168.100.1"
    echo "🚀 De PLD-straat is klaar voor gebruik!"
else
    echo "⚠️  LET OP: De interface 192.168.100.1 is nog niet gedetecteerd."
    echo "Zorg dat de kabel in de tweede netwerkkaart zit en verbonden is met de switch."
fi

echo "--- Installatie Voltooid! ---"
