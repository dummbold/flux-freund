#!/bin/bash

# NUT (Network UPS Tools) Installation Script
# For Accurat Flux 850 UPS on Linux
# Created: January 2026

set -e  # Exit on error

echo "========================================"
echo "NUT Server Installation for FLUX 850 UPS"
echo "========================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run with sudo: sudo bash $0"
    exit 1
fi

# Password input
echo "Set password for NUT access:"
read -s -p "Set Password: " NUT_PASSWORD
echo ""
read -s -p "Confirm Password: " NUT_PASSWORD_CONFIRM
echo ""

if [ "$NUT_PASSWORD" != "$NUT_PASSWORD_CONFIRM" ]; then
    echo "Error: Passwords do not match!"
    exit 1
fi

if [ -z "$NUT_PASSWORD" ]; then
    echo "Error: Password cannot be empty!"
    exit 1
fi

echo ""
echo "Step 1/5: Installing NUT Server..."
apt-get update
apt-get install -y nut nut-server

echo ""
echo "Step 2/5: Creating UPS configuration (/etc/nut/ups.conf)..."
cat > /etc/nut/ups.conf << EOF
[accurat]
driver = usbhid-ups
port = auto
desc = "Accurat Flux 850"
EOF

echo ""
echo "Step 3/5: Configuring NUT mode (/etc/nut/nut.conf)..."
cat > /etc/nut/nut.conf << EOF
MODE=standalone
EOF

echo ""
echo "Step 4/5: Configuring users and permissions (/etc/nut/upsd.users)..."
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
echo "Step 5/5: Starting NUT services..."
systemctl restart nut-driver
systemctl restart nut-server
systemctl enable nut-driver
systemctl enable nut-server

echo ""
echo "=================================="
echo "Installation completed!"
echo "=================================="
echo ""
echo "Testing UPS connection..."
upsdrvctl start

echo ""
echo "UPS Status:"
upsc accurat@localhost

echo ""
echo "=================================="
echo "Next Steps:"
echo "=================================="
echo "1. For HomeAssistant integration:"
echo "   - Host: $(hostname -I | awk '{print $1}')"
echo "   - Port: 3493"
echo "   - Username: monitor"
echo "   - Password: [your set password]"
echo ""
echo "2. Show UPS status: upsc accurat@localhost"
echo "3. Start NUT Monitor GUI (if installed)"
echo ""
