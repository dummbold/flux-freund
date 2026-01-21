#!/bin/bash

# NUT (Network UPS Tools) Installation Script
# For Accurat Flux 850 UPS on Linux
# Created: January 2026

set -e  # Exit on error

echo "=================================================="
echo "Installation du serveur NUT pour onduleur FLUX 850"
echo "=================================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Veuillez exécuter avec sudo: sudo bash $0"
    exit 1
fi

# Password input
echo "Veuillez définir le mot de passe pour l'accès NUT:"
read -s -p "Définir le mot de passe: " NUT_PASSWORD
echo ""
read -s -p "Confirmer le mot de passe: " NUT_PASSWORD_CONFIRM
echo ""

if [ "$NUT_PASSWORD" != "$NUT_PASSWORD_CONFIRM" ]; then
    echo "Erreur: Les mots de passe ne correspondent pas!"
    exit 1
fi

if [ -z "$NUT_PASSWORD" ]; then
    echo "Erreur: Le mot de passe ne peut pas être vide!"
    exit 1
fi

echo ""
echo "Étape 1/5: Installation du serveur NUT..."
apt-get update
apt-get install -y nut nut-server

echo ""
echo "Étape 2/5: Création de la configuration de l'onduleur (/etc/nut/ups.conf)..."
cat > /etc/nut/ups.conf << EOF
[accurat]
driver = usbhid-ups
port = auto
desc = "Accurat Flux 850"
EOF

echo ""
echo "Étape 3/5: Configuration du mode NUT (/etc/nut/nut.conf)..."
cat > /etc/nut/nut.conf << EOF
MODE=standalone
EOF

echo ""
echo "Étape 4/5: Configuration des utilisateurs et permissions (/etc/nut/upsd.users)..."
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
echo "Étape 5/5: Démarrage des services NUT..."
systemctl restart nut-driver
systemctl restart nut-server
systemctl enable nut-driver
systemctl enable nut-server

echo ""
echo "=================================="
echo "Installation terminée!"
echo "=================================="
echo ""
echo "Test de la connexion de l'onduleur..."
upsdrvctl start

echo ""
echo "État de l'onduleur:"
upsc accurat@localhost

echo ""
echo "=================================="
echo "Prochaines étapes:"
echo "=================================="
echo "1. Pour l'intégration HomeAssistant:"
echo "   - Hôte: $(hostname -I | awk '{print $1}')"
echo "   - Port: 3493"
echo "   - Nom d'utilisateur: monitor"
echo "   - Mot de passe: [votre mot de passe défini]"
echo ""
echo "2. Afficher l'état de l'onduleur: upsc accurat@localhost"
echo "3. Démarrer l'interface graphique NUT Monitor (si installée)"
echo ""
