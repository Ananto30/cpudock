#!/bin/bash

set -e

SCRIPT_PATH="$(realpath ./cpudock.py)"
SCRIPT_NAME="cpudock"
AUTOSTART_DIR="$HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/${SCRIPT_NAME}.desktop"

echo "🚀 Installing system dependencies..."
sudo apt update
sudo apt install -y python3-gi gir1.2-gtk-3.0 gir1.2-appindicator3-0.1 libgtk-3-dev python3-psutil

echo "🔒 Making script executable..."
chmod +x "$SCRIPT_PATH"

echo "📁 Creating autostart directory if needed..."
mkdir -p "$AUTOSTART_DIR"

echo "📝 Creating autostart .desktop file at $DESKTOP_FILE..."
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Exec=/usr/bin/python3 $SCRIPT_PATH
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=CPU Dock Monitor
Comment=Shows CPU usage, RAM, and temperature in the system tray
EOF

echo "✅ Installation complete!"
echo "📌 This script will auto-start on your next login."
echo "▶️ Launching now..."

nohup /usr/bin/python3 "$SCRIPT_PATH" >/dev/null 2>&1 & disown
