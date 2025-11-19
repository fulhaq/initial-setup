# Initial Setup Script

A bash script to quickly install essential Flatpak applications: Google Chrome, Obsidian, and Dropbox.

## What This Script Does

This script automates the installation of the following applications via Flatpak:

- **Google Chrome** - Web browser
- **Obsidian** - Note-taking and knowledge management application
- **Dropbox** - Cloud storage and file synchronization

## Prerequisites

- **Flatpak** must be installed on your system
  - For Debian/Ubuntu: `sudo apt install flatpak`
  - For Fedora: `sudo dnf install flatpak`
  - For other distributions, refer to the [Flatpak installation guide](https://flatpak.org/setup/)

## Installation Methods

### Method 1: Download and Execute Directly from Git

You can download and run the script directly without cloning the repository:

```bash
# Using curl
curl -sSL https://raw.githubusercontent.com/fulhaq/initial-setup/main/setup.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/fulhaq/initial-setup/main/setup.sh | bash
```

### Method 2: Download First, Then Execute

If you prefer to review the script before running it:

```bash
# Download the script
curl -sSL https://raw.githubusercontent.com/fulhaq/initial-setup/main/setup.sh -o setup.sh

# Make it executable
chmod +x setup.sh

# Review the script (optional)
cat setup.sh

# Run the script
./setup.sh
```

### Method 3: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/fulhaq/initial-setup.git
cd initial-setup

# Make the script executable
chmod +x setup.sh

# Run the script
./setup.sh
```

## What the Script Does

1. **Checks for Flatpak**: Verifies that Flatpak is installed on your system
2. **Adds Flathub Remote**: Automatically adds the Flathub repository if it's not already configured
3. **Updates Remotes**: Updates Flatpak remotes to ensure you have the latest package information
4. **Installs Applications**: Installs all three applications with automatic confirmation

## Running Installed Applications

After installation, you can launch the applications in several ways:

### From Application Menu

The applications will appear in your system's application menu.

### From Command Line

```bash
# Launch Google Chrome
flatpak run com.google.Chrome

# Launch Obsidian
flatpak run md.obsidian.Obsidian

# Launch Dropbox
flatpak run com.dropbox.Client
```

## Troubleshooting

### Flatpak Not Found

If you see an error that Flatpak is not installed, install it first:

- **Debian/Ubuntu**: `sudo apt install flatpak`
- **Fedora**: `sudo dnf install flatpak`
- After installation, you may need to log out and log back in for Flatpak to work properly.

### Permission Issues

If you encounter permission issues, ensure you have the necessary permissions to install Flatpak applications. Some systems may require additional setup.

### Flathub Remote Issues

If the Flathub remote cannot be added, you can manually add it:

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

## Uninstalling Applications

If you need to uninstall any of the applications:

```bash
# Uninstall Google Chrome
flatpak uninstall com.google.Chrome

# Uninstall Obsidian
flatpak uninstall md.obsidian.Obsidian

# Uninstall Dropbox
flatpak uninstall com.dropbox.Client
```

## License

This script is provided as-is for personal use.
