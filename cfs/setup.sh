#!/bin/bash

echo "HAFIZUDDIN'S SETUP FILE"

echo

echo "Starting system setup..."

# Detect package manager (Debian-based vs. Arch)
if command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt install -y"
    UPDATE_CMD="sudo apt update && sudo apt upgrade -y"
    CLEAN_CMD="sudo apt autoremove -y && sudo apt clean"
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
    UPDATE_CMD="sudo pacman -Syu --noconfirm"
    CLEAN_CMD="sudo pacman -Rns $(pacman -Qdtq) --noconfirm"
else
    echo "❌ Unsupported package manager. Exiting."
    exit 1
fi

# Update repositories and upgrade system
echo "🔄 Updating package repositories..."
$UPDATE_CMD

# Install essential apps (modify this list as needed)
APPS=(
    curl
    wget
    git
    vim
    htop
    unzip
    gnome-tweaks
)

echo "📦 Installing essential apps: ${APPS[*]}"
$INSTALL_CMD "${APPS[@]}"

# Install Deadbeef
echo "🎵 Installing Deadbeef..."

if [ "$PKG_MANAGER" = "apt" ]; then
    echo "🔍 Searching for the latest Deadbeef package from SourceForge..."
    DEADBEAF_URL=$(curl -s "https://sourceforge.net/projects/deadbeef/rss?path=/travis/linux/amd64" | grep -oP 'https://downloads\.sourceforge\.net/project/deadbeef/[^"]+' | head -n 1)

    if [[ -n "$DEADBEAF_URL" ]]; then
        echo "📥 Downloading Deadbeef from: $DEADBEAF_URL"
        wget -O deadbeef.deb "$DEADBEAF_URL"
        echo "💿 Installing Deadbeef..."
        sudo dpkg -i deadbeef.deb
        sudo apt --fix-broken install -y  # Fix any missing dependencies
        rm deadbeef.deb  # Clean up
    else
        echo "❌ Failed to find Deadbeef package. Check SourceForge manually."
    fi
elif [ "$PKG_MANAGER" = "pacman" ]; then
    echo "🔧 Installing Deadbeef from AUR..."
    if command -v paru &>/dev/null; then
        paru -S --noconfirm deadbeef
    elif command -v yay &>/dev/null; then
        yay -S --noconfirm deadbeef
    else
        echo "⚠️ No AUR helper (paru/yay) found. Install one manually and rerun the script."
    fi
fi

# Download and install Google Chrome (different for Debian & Arch)
echo "🌍 Fetching Google Chrome..."

if [ "$PKG_MANAGER" = "apt" ]; then
    wget -q -O google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    echo "💿 Installing Google Chrome..."
    sudo dpkg -i google-chrome.deb
    sudo apt --fix-broken install -y  # Fix dependencies if needed
    rm google-chrome.deb  # Clean up
elif [ "$PKG_MANAGER" = "pacman" ]; then
    echo "🔧 Installing Google Chrome from AUR..."
    if command -v paru &>/dev/null; then
        paru -S --noconfirm google-chrome
    elif command -v yay &>/dev/null; then
        yay -S --noconfirm google-chrome
    else
        echo "⚠️ No AUR helper (paru/yay) found. Install one manually and rerun the script."
    fi
fi

# Cleanup
echo "🧹 Cleaning up..."
$CLEAN_CMD

echo "✅ System setup complete! 🚀"
