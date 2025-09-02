#!/bin/bash

echo "⚠️  This script will REMOVE MPD & Ymuse, REVERT user changes, and REINSTALL them fresh!"
read -rp "Continue? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "❌ Aborted."
    exit 1
fi

echo "🛑 Stopping MPD..."
sudo systemctl stop mpd
sudo systemctl disable mpd

echo "🔥 Removing MPD, Ymuse, and dependencies..."
if command -v pacman &>/dev/null; then
    sudo pacman -Rns --noconfirm mpd mpc ncmpcpp ymuse
    sudo pacman -Scc --noconfirm  # Clean package cache
elif command -v apt &>/dev/null; then
    sudo apt remove --purge -y mpd mpc ncmpcpp ymuse
    sudo apt autoremove -y
    sudo apt clean
elif command -v dnf &>/dev/null; then
    sudo dnf remove -y mpd mpc ncmpcpp ymuse
    sudo dnf autoremove -y
elif command -v zypper &>/dev/null; then
    sudo zypper remove -y mpd mpc ncmpcpp ymuse
else
    echo "⚠️  Package manager not detected. Remove MPD & Ymuse manually."
fi

echo "🗑️  Deleting MPD & Ymuse configuration files..."
sudo rm -rf /etc/mpd.conf /var/lib/mpd ~/.mpd ~/.config/mpd ~/.config/ymuse

echo "🔄 Reverting user modifications..."
sudo usermod -G users,audio danish  # Replace 'danish' with your username
sudo chown -R danish:danish /home/danish

echo "📦 Removing leftover MPD & Ymuse-related files..."
sudo rm -rf /var/log/mpd.log /var/run/mpd /run/mpd /home/danish/.mpd* /home/danish/.local/share/ymuse

echo "✅ MPD & Ymuse have been completely removed and user modifications reverted."

echo "📥 Reinstalling MPD & Ymuse..."
if command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm mpd mpc ncmpcpp ymuse
elif command -v apt &>/dev/null; then
    sudo apt install -y mpd mpc ncmpcpp ymuse
elif command -v dnf &>/dev/null; then
    sudo dnf install -y mpd mpc ncmpcpp ymuse
elif command -v zypper &>/dev/null; then
    sudo zypper install -y mpd mpc ncmpcpp ymuse
else
    echo "⚠️  Could not reinstall MPD & Ymuse. Install them manually if needed."
    exit 1
fi

echo "📂 Creating a fresh MPD configuration..."
mkdir -p ~/.config/mpd
cp /usr/share/doc/mpd/mpd.conf.example ~/.config/mpd/mpd.conf
sed -i 's/#music_directory ".*"/music_directory "\/home\/danish\/Music"/' ~/.config/mpd/mpd.conf  # Adjust path

echo "🔄 Enabling and starting MPD..."
sudo systemctl enable mpd
sudo systemctl start mpd

echo "🎵 MPD & Ymuse reset & reinstallation complete!"
