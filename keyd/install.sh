#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/keyd.conf"

echo "=== keyd Installation Script ==="

# Check if keyd is installed (check package, not command, as binary may vary)
if ! dpkg -l keyd &> /dev/null; then
    echo "keyd is not installed. Install it with:"
    echo "  sudo apt install keyd"
    exit 1
fi

# Find keyd binary (Ubuntu uses keyd.rvaiya, upstream uses keyd)
KEYD_BIN=$(command -v keyd 2>/dev/null || command -v keyd.rvaiya 2>/dev/null || echo "/usr/bin/keyd.rvaiya")

# Create /etc/keyd if it doesn't exist
sudo mkdir -p /etc/keyd

# Symlink config
echo "Symlinking $CONFIG_FILE -> /etc/keyd/default.conf"
sudo ln -sf "$CONFIG_FILE" /etc/keyd/default.conf

# Enable and start/reload keyd
if systemctl is-active --quiet keyd; then
    echo "Reloading keyd..."
    sudo "$KEYD_BIN" reload
else
    echo "Enabling and starting keyd service..."
    sudo systemctl enable --now keyd
fi

echo ""
echo "=== Done! ==="
echo "Panic sequence if something goes wrong: backspace + escape + enter"
echo "To check status: sudo systemctl status keyd"
echo "To view logs: sudo journalctl -eu keyd"
