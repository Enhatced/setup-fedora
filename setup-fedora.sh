#!/bin/bash
set -e

echo "🔄 Actualizando sistema..."
sudo dnf -y update

echo "📦 Instalando herramientas básicas..."
sudo dnf install -y \
    git \
    curl \
    wget \
    htop \
    tree \
    p7zip p7zip-plugins \
    gnome-tweaks \
    python3 python3-pip python3-venv \
    postgresql postgresql-server \
    wireshark \
    nmap \
    gimp

echo "🐳 Instalando Docker..."
sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine || true
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

echo "🖥 Instalando VSCode..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo'
sudo dnf install -y code

echo "🌐 Instalando navegadores..."
sudo dnf install -y firefox
# Brave
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install -y brave-browser
# Edge
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
sudo dnf install -y microsoft-edge-stable

echo "📬 Instalando Postman..."
POSTMAN_URL="https://dl.pstmn.io/download/latest/linux64"
wget -O postman.tar.gz $POSTMAN_URL
sudo tar -xzf postman.tar.gz -C /opt
sudo ln -sf /opt/Postman/Postman /usr/local/bin/postman
rm postman.tar.gz

echo "🛡 Instalando Burp Suite Community..."
BURP_URL="https://portswigger.net/burp/releases/download?product=community&version=2025.1&type=Linux"
wget -O burpsuite.sh "$BURP_URL"
chmod +x burpsuite.sh
sudo ./burpsuite.sh
rm burpsuite.sh

echo "💻 Instalando Warp Terminal..."
WARP_URL="https://releases.warp.dev/stable/latest/warp-terminal-latest-x86_64.rpm"
wget -O warp-terminal.rpm "$WARP_URL"
sudo dnf install -y ./warp-terminal.rpm
rm warp-terminal.rpm

echo "📄 Instalando WPS Office..."
wget -O wps-office.rpm https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/11702/wps-office-11.1.0.11702.XA-1.x86_64.rpm
sudo dnf install -y ./wps-office.rpm
rm wps-office.rpm

echo "✅ Instalación completada. Reinicia la sesión para aplicar cambios de Docker."
