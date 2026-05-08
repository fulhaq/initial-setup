#!/bin/bash

# To download and execute this script directly from git, run:
#   curl -sSL https://raw.githubusercontent.com/fulhaq/initial-setup/main/setup.sh | bash
#   OR
#   wget -qO- https://raw.githubusercontent.com/fulhaq/initial-setup/main/setup.sh | bash
#   OR download first, then execute:
#   curl -sSL https://raw.githubusercontent.com/fulhaq/initial-setup/main/setup.sh -o setup.sh && chmod +x setup.sh && ./setup.sh

# Setup script to install Flatpak applications: Google Chrome, Obsidian, and Dropbox
# Also installs Cursor editor

set -e  # Exit on error

echo "Starting installation process..."

# Add GitHub CLI apt repository
echo "Adding GitHub CLI repository..."
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Install apt packages
echo "Installing apt packages..."
sudo apt-get update -y
sudo apt-get install -y stow eza gh

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

# Install Cursor
echo ""
echo "Installing Cursor editor..."
CURSOR_DEB_URL="https://www.cursor.com/downloads/cursor-latest_amd64.deb"
CURSOR_DEB_PATH="/tmp/cursor-latest_amd64.deb"

# Check if we have wget or curl
if command -v wget &> /dev/null; then
    echo "Downloading Cursor..."
    wget -O "$CURSOR_DEB_PATH" "$CURSOR_DEB_URL"
elif command -v curl &> /dev/null; then
    echo "Downloading Cursor..."
    curl -L "$CURSOR_DEB_URL" -o "$CURSOR_DEB_PATH"
else
    echo "Error: Neither wget nor curl is available. Cannot download Cursor."
    exit 1
fi

# Install the package
if [ -f "$CURSOR_DEB_PATH" ]; then
    echo "Installing Cursor package..."
    sudo dpkg -i "$CURSOR_DEB_PATH" || true
    
    # Fix any missing dependencies
    echo "Fixing dependencies..."
    sudo apt-get install -f -y
    
    # Clean up
    rm -f "$CURSOR_DEB_PATH"
    echo "Cursor installation complete!"
else
    echo "Error: Failed to download Cursor package."
    exit 1
fi

# Pin applications to Cosmic desktop taskbar
echo ""
echo "Pinning applications to Cosmic desktop taskbar..."

if command -v dconf &> /dev/null; then
    # Function to add app to favorites if not already present
    pin_to_taskbar() {
        local app_desktop=$1
        local favorites_path="/org/gnome/shell/favorite-apps"
        
        # Get current favorites
        local current_favorites=$(dconf read "$favorites_path" 2>/dev/null || echo "[]")
        
        # Check if app is already in favorites
        if echo "$current_favorites" | grep -q "$app_desktop"; then
            echo "  $app_desktop is already pinned"
            return
        fi
        
        # Add app to favorites
        if [ "$current_favorites" = "[]" ]; then
            # Empty list, create new one
            dconf write "$favorites_path" "['$app_desktop']" 2>/dev/null || true
        else
            # Append to existing list
            local new_favorites=$(echo "$current_favorites" | sed "s/\]$/, '$app_desktop']/")
            dconf write "$favorites_path" "$new_favorites" 2>/dev/null || true
        fi
        
        echo "  Pinned $app_desktop to taskbar"
    }
    
    # Pin Chrome and Obsidian
    pin_to_taskbar "com.google.Chrome.desktop"
    pin_to_taskbar "md.obsidian.Obsidian.desktop"
    
    echo "Taskbar pinning complete!"
else
    echo "  dconf not found. Skipping taskbar pinning."
    echo "  You can manually pin applications from the application menu."
fi

echo ""
echo "Installation complete! The following applications have been installed:"
echo "  - stow"
echo "  - eza"
echo "  - gh (GitHub CLI)"
echo "  - Google Chrome (com.google.Chrome)"
echo "  - Obsidian (md.obsidian.Obsidian)"
echo "  - Dropbox (com.dropbox.Client)"
echo "  - Cursor editor"
echo ""
echo "You can launch them from your application menu or run:"
echo "  flatpak run com.google.Chrome"
echo "  flatpak run md.obsidian.Obsidian"
echo "  flatpak run com.dropbox.Client"
echo "  cursor"

