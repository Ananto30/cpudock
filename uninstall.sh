#!/bin/bash

set -e

SCRIPT_NAME="cpudock"
AUTOSTART_FILE="$HOME/.config/autostart/${SCRIPT_NAME}.desktop"
SCRIPT_PATH="$(realpath ./cpudock.py)"

echo "🗑️ Uninstalling CPU Dock Monitor..."

# Remove the autostart .desktop file
if [ -f "$AUTOSTART_FILE" ]; then
    echo "🔹 Removing autostart entry..."
    rm "$AUTOSTART_FILE"
else
    echo "⚠️ No autostart file found at $AUTOSTART_FILE"
fi

# Ask if user wants to remove the script itself
read -p "❓ Do you want to delete the script itself at $SCRIPT_PATH? [y/N]: " confirm
confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')  # to lowercase

if [[ "$confirm" == "y" ]]; then
    if [ -f "$SCRIPT_PATH" ]; then
        echo "🔹 Deleting script..."
        rm "$SCRIPT_PATH"
    else
        echo "⚠️ Script not found."
    fi
else
    echo "✅ Script left untouched."
fi

echo "✅ Uninstallation complete!"
