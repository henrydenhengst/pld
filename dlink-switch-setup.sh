#!/bin/bash
# Instellingen voor jouw switch
SWITCH_IP="192.168.1.2"
USER="admin"
PASS="jouwwachtwoord"

sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$SWITCH_IP << EOF
configure terminal
# 1. Optimaliseer de 3 Gbps verdeling (De 3 rode kabels)
port-channel load-balance src-dst-ip-l4port

# 2. Optimaliseer de 10 blauwe poorten
interface range ethernet 1/0/1-10
  no green-ethernet
  spanning-tree portfast
  storm-control broadcast level 5
  exit

# 3. Opslaan
copy running-config startup-config
exit
EOF

echo "D-Link is nu geoptimaliseerd voor 60 desktops per uur!"
