#!/bin/bash

# PLD Server Installatie Script
# Dit script bereidt de server voor en start de Ansible configuratie.

set -e

echo "--- Starten van PLD Server Installatie ---"

# 1. Update systeem en installeer basis benodigdheden
echo "Stap 1: Systeem update en basis pakketten installeren..."
sudo apt update && sudo apt install -y git ansible python3-pip

# 2. Installeer benodigde Ansible collecties (nodig voor nmcli/netwerk)
echo "Stap 2: Ansible collecties installeren..."
ansible-galaxy collection install community.general ansible.posix

# 3. Uitvoeren van het hoofd-playbook
echo "Stap 3: Starten van de Ansible configuratie (Netwerk & Software)..."
# We gebruiken localhost omdat we op de server zelf draaien
sudo ansible-playbook -i "localhost," -c local playbooks/server.yml

echo "--- Installatie Voltooid! ---"
echo "De server is nu geconfigureerd als Gateway op 192.168.100.1"
