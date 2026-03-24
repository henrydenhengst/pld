#!/bin/bash

# =============================================================
# PLD SLUIS-VERIFIER - CHECK JE MOEDERSCHIP
# =============================================================

echo "--- 🔍 Controleren van Sluis-Model Services ---"

# 1. Check Apt-Proxy (Poort 3142)
if lsof -Pi :3142 -sTCP:LISTEN -t >/dev/null ; then
    echo "✅ Apt-Cacher-NG is actief op poort 3142"
else
    echo "❌ Apt-Cacher-NG DRAAIT NIET! (sudo systemctl start apt-cacher-ng)"
fi

# 2. Check TFTP (Poort 69)
if ss -u -a | grep -q ":69 " ; then
    echo "✅ TFTP-server luistert op poort 69"
else
    echo "❌ TFTP DRAAIT NIET! (sudo systemctl start tftpd-hpa)"
fi

# 3. Check Nginx/Preseed (Poort 80)
if curl -s --head  http://192.168.100.1/preseed.cfg | head -n 1 | grep "200" > /dev/null; then
    echo "✅ Preseed-file is bereikbaar via HTTP"
else
    echo "❌ Preseed-file NIET BEREIKBAAR op http://192.168.100.1/preseed.cfg"
fi

# 4. Check IP Forwarding
if [ "$(cat /proc/sys/net/ipv4/ip_forward)" -eq 1 ]; then
    echo "✅ IPv4 Forwarding (De Sluis) staat AAN"
else
    echo "❌ IPv4 Forwarding staat UIT! (Sluis is geblokkeerd)"
fi

echo "-----------------------------------------------"
