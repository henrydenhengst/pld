#!/bin/bash
set -e

echo ">>> GRUB Silent Boot configuratie starten..."

# 1. Backup maken
sudo cp /etc/default/grub /etc/default/grub.bak

# 2. Parameters aanpassen
# Timeout naar 0 en alle log-vervuiling naar de achtergrond
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3 vt.global_cursor_default=0"/' /etc/default/grub

# Fix voor systemen die blijven hangen op recordfail
if ! grep -q "GRUB_RECORDFAIL_TIMEOUT" /etc/default/grub; then
    echo "GRUB_RECORDFAIL_TIMEOUT=0" | sudo tee -a /etc/default/grub
fi

# 3. GRUB Config genereren (Distro check)
if command -v update-grub &> /dev/null; then
    sudo update-grub
elif [ -f /boot/grub/grub.cfg ]; then
    sudo grub-mkconfig -o /boot/grub/grub.cfg
elif [ -f /boot/efi/EFI/fedora/grub.cfg ]; then
    sudo grub-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
else
    echo "Fout: Kan GRUB config locatie niet vinden. Update handmatig."
    exit 1
fi

echo ">>> GRUB is nu stil en de timeout staat op 0. Bij de volgende reboot is de chaos weg."
