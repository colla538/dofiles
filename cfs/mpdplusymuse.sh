#!/bin/bash

# Function to check package manager
check_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    else
        echo "Unsupported system"
        exit 1
    fi
}

# Detect package manager
PKG_MANAGER=$(check_package_manager)

# Remove DeaDBeeF if installed
if command -v deadbeef &> /dev/null; then
    echo "Removing DeaDBeeF..."
    if [ "$PKG_MANAGER" = "apt" ]; then
        sudo apt remove --purge -y deadbeef deadbeef-* 
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        sudo pacman -Rns --noconfirm deadbeef deadbeef-* 
    fi
else
    echo "DeaDBeeF is not installed."
fi

# Install MPD + Ymuse
echo "Installing MPD and Ymuse..."
if [ "$PKG_MANAGER" = "apt" ]; then
    sudo apt update
    sudo apt install -y mpd ymuse
elif [ "$PKG_MANAGER" = "pacman" ]; then
    sudo pacman -Syu --noconfirm mpd ymuse
fi

# Enable and start MPD
sudo systemctl enable --now mpd

echo "MPD and Ymuse installation complete!"
