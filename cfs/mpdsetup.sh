#!/bin/bash

# Prompt user for music directory
read -p "Enter your music directory path: " MUSIC_DIR

# Define variables
MPD_CONF="/etc/mpd.conf"

# Ensure MPD and Ymuse are installed
if ! command -v mpd &> /dev/null; then
    echo "MPD is not installed. Installing..."
    sudo apt install -y mpd || sudo pacman -S --noconfirm mpd
fi

if ! command -v ymuse &> /dev/null; then
    echo "Ymuse is not installed. Installing..."
    sudo apt install -y ymuse || sudo pacman -S --noconfirm ymuse
fi

# Prompt user to insert DACs and wait for detection
while true; do
    echo "Please connect your DACs. Waiting for detection..."
    sleep 5
    aplay -l
    read -p "Have all DACs been detected? (y/n): " CONFIRMED
    [[ "$CONFIRMED" == "y" ]] && break
    echo "Ensure your DACs are properly connected."
    sleep 2
done

echo "Proceeding with setup."

# Modify MPD configuration
sudo sed -i 's|^#music_directory.*|music_directory "'$MUSIC_DIR'"|' $MPD_CONF
sudo sed -i 's|^#db_file.*|db_file "/var/lib/mpd/tag_cache"|' $MPD_CONF
sudo sed -i 's|^#pid_file.*|pid_file "/run/mpd/pid"|' $MPD_CONF
sudo sed -i 's|^#state_file.*|state_file "/var/lib/mpd/state"|' $MPD_CONF
sudo sed -i 's|^#bind_to_address.*|bind_to_address "any"|' $MPD_CONF
sudo sed -i 's|^#port.*|port "6600"|' $MPD_CONF
sudo sed -i 's|^#restore_paused.*|restore_paused "yes"|' $MPD_CONF

# Add selectable audio outputs
cat <<EOL | sudo tee -a $MPD_CONF

audio_output {
    type "alsa"
    name "DAC 1"
    device "hw:1,0"
}

audio_output {
    type "alsa"
    name "DAC 2"
    device "hw:1,0"
}
EOL

# Fix permissions
sudo usermod -aG audio mpd
sudo chmod -R 755 "$MUSIC_DIR"
sudo chown -R mpd:audio "$MUSIC_DIR"

# Restart MPD
sudo systemctl restart mpd

# Final MPD status
sudo systemctl status mpd --no-pager
