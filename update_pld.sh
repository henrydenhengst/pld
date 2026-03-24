#!/usr/bin/env bash
# PLD Project Refactor v1.0
set -e

PROJECT_DIR="$HOME/git/pld"
cd "$PROJECT_DIR"

echo "🛠️  1. Common rol vullen met hardware-detectie..."
cat << 'INNER_EOF' > roles/common/tasks/main.yml
---
- name: Update apt cache
  apt:
    update_cache: yes
    cache_valid_time: 3600

- name: Installeer basis systeemtools
  apt:
    name: [curl, wget, git, htop, net-tools, p7zip-full, vim]
    state: present

- name: Automatische Hardware Detectie - Microcode
  apt:
    name: "{{ 'intel-microcode' if ansible_processor[1] is search('Intel') else 'amd64-microcode' }}"
    state: present

- name: Check voor Nvidia GPU
  shell: lspci | grep -i nvidia
  register: nvidia_check
  ignore_errors: yes
  changed_when: false

- name: Installeer Nvidia drivers indien nodig
  apt:
    name: nvidia-driver
    state: present
  when: nvidia_check.rc == 0

- name: Installeer Standaard Kantoor Software
  apt:
    name: [libreoffice, libreoffice-l10n-nl, vlc, firefox-esr, thunderbird]
    state: present

- name: Systeeminstellingen (Tijd & Taal)
  timezone:
    name: Europe/Amsterdam
INNER_EOF

echo "🛠️  2. Playbook site.yml stroomlijnen..."
cat << 'INNER_EOF' > playbooks/site.yml
---
- hosts: localhost
  connection: local
  become: yes
  roles:
    - common
    - "{{ profile | default('office') }}"
INNER_EOF

echo "🚀 3. Alles naar GitHub pushen..."
git add .
git commit -m "Refactor: Alle losse scripts samengevoegd in de Common rol"
git push origin main

echo "✅ KLAAR! Je 'recepten' staan nu up-to-date op GitHub."
