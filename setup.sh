#!/bin/bash

# To download and execute this script directly from git, run:
#   curl -sSL https://raw.githubusercontent.com/fulhaq/initial-setup/main/setup.sh | bash
#   OR
#   wget -qO- https://raw.githubusercontent.com/fulhaq/initial-setup/main/setup.sh | bash
#   OR download first, then execute:
#   curl -sSL https://raw.githubusercontent.com/fulhaq/initial-setup/main/setup.sh -o setup.sh && chmod +x setup.sh && ./setup.sh

# Setup script to install Flatpak applications: Google Chrome, Obsidian, and Dropbox

set -e  # Exit on error

echo "Starting Flatpak application installation..."

# Check if flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo "Flatpak is not installed. Please install it first:"
    echo "  sudo apt install flatpak  # For Debian/Ubuntu"
    echo "  sudo dnf install flatpak  # For Fedora"
    exit 1
fi

# Add Flathub remote if it doesn't exist
if ! flatpak remote-list | grep -q flathub; then
    echo "Adding Flathub remote..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

# Update flatpak remotes
echo "Updating Flatpak remotes..."
flatpak update -y

# Install Google Chrome
echo "Installing Google Chrome..."
flatpak install -y flathub com.google.Chrome

# Install Obsidian
echo "Installing Obsidian..."
flatpak install -y flathub md.obsidian.Obsidian

# Install Dropbox
echo "Installing Dropbox..."
flatpak install -y flathub com.dropbox.Client

echo ""
echo "Installation complete! The following applications have been installed:"
echo "  - Google Chrome (com.google.Chrome)"
echo "  - Obsidian (md.obsidian.Obsidian)"
echo "  - Dropbox (com.dropbox.Client)"
echo ""
echo "You can launch them from your application menu or run:"
echo "  flatpak run com.google.Chrome"
echo "  flatpak run md.obsidian.Obsidian"
echo "  flatpak run com.dropbox.Client"

