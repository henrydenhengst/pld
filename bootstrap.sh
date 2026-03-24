#!/usr/bin/env bash
# PLD Bootstrap v1.0
set -e

echo "🚀 Starten van de PLD-installatie..."

# 1. Update en installeer de basis
sudo apt update
sudo apt install -y ansible git

# 2. Draai de configuratie direct vanaf GitHub
sudo ansible-pull -U git@github.com:henrydenhengst/pld.git     -i localhost,     -e "profile=${1:-office}"     playbooks/site.yml

echo "✅ Installatie voltooid! Herstart de machine."
