#!/bin/bash

# NUT (Network UPS Tools) Installation Script
# For Accurat Flux 850 USV on Linux
# Created: January 2026

set -e  # Exit on error

echo "=================================="
echo "NUT Server Installation für USV"
echo "=================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Bitte mit sudo ausführen: sudo bash $0"
    exit 1
fi

# Password input
echo "Bitte Passwort für NUT-Zugriff festlegen:"
read -s -p "Set Password: " NUT_PASSWORD
echo ""
read -s -p "Passwort bestätigen: " NUT_PASSWORD_CONFIRM
echo ""

if [ "$NUT_PASSWORD" != "$NUT_PASSWORD_CONFIRM" ]; then
    echo "Fehler: Passwörter stimmen nicht überein!"
    exit 1
fi

if [ -z "$NUT_PASSWORD" ]; then
    echo "Fehler: Passwort darf nicht leer sein!"
    exit 1
fi

echo ""
echo "Step 1/5: NUT Server installieren..."
apt-get update
apt-get install -y nut nut-server

echo ""
echo "Step 2/5: USV-Konfiguration erstellen (/etc/nut/ups.conf)..."
cat > /etc/nut/ups.conf << EOF
[accurat]
driver = usbhid-ups
port = auto
desc = "Accurat Flux 850"
EOF

echo ""
echo "Step 3/5: NUT-Modus konfigurieren (/etc/nut/nut.conf)..."
cat > /etc/nut/nut.conf << EOF
MODE=standalone
EOF

echo ""
echo "Step 4/5: Benutzer und Rechte konfigurieren (/etc/nut/upsd.users)..."
cat > /etc/nut/upsd.users << EOF
[admin]
password = $NUT_PASSWORD
actions = SET
instcmds = ALL

[monitor]
password = $NUT_PASSWORD
upsmon master
EOF

echo ""
echo "Step 5/5: NUT-Dienste starten..."
systemctl restart nut-driver
systemctl restart nut-server
systemctl enable nut-driver
systemctl enable nut-server

echo ""
echo "=================================="
echo "Installation abgeschlossen!"
echo "=================================="
echo ""
echo "Teste USV-Verbindung..."
upsdrvctl start

echo ""
echo "USV-Status:"
upsc accurat@localhost

echo ""
echo "=================================="
echo "Nächste Schritte:"
echo "=================================="
echo "1. Für HomeAssistant-Integration:"
echo "   - Host: $(hostname -I | awk '{print $1}')"
echo "   - Port: 3493"
echo "   - Username: monitor"
echo "   - Password: [dein gesetztes Passwort]"
echo ""
echo "2. USV-Status anzeigen: upsc accurat@localhost"
echo "3. NUT Monitor GUI starten (falls installiert)"
echo ""
