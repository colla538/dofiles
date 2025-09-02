#!/bin/bash

# MPD Configuration Setup Script

MPD_CONF="/etc/mpd.conf"
MUSIC_DIR="/media/danish/USB_Music/"
MPD_USER="mpd"
MPD_GROUP="audio"

# Ensure the required directories exist
sudo mkdir -p /run/mpd /var/lib/mpd
sudo chown $MPD_USER:$MPD_GROUP /run/mpd /var/lib/mpd
sudo chmod 755 /run/mpd /var/lib/mpd

# Modify MPD configuration
sudo sed -i 's|^#music_directory.*|music_directory "'$MUSIC_DIR'"|' $MPD_CONF
sudo sed -i 's|^#db_file.*|db_file "'/var/lib/mpd/tag_cache'"|' $MPD_CONF
sudo sed -i 's|^#pid_file.*|pid_file "'/run/mpd/pid'"|' $MPD_CONF
sudo sed -i 's|^#state_file.*|state_file "'/var/lib/mpd/state'"|' $MPD_CONF
sudo sed -i 's|^#bind_to_address.*|bind_to_address "localhost"|' $MPD_CONF
sudo sed -i 's|^#port.*|port "6600"|' $MPD_CONF
sudo sed -i 's|^#restore_paused.*|restore_paused "yes"|' $MPD_CONF

# Define audio outputs
if ! grep -q 'audio_output {' $MPD_CONF; then
  echo "Adding audio outputs..."
  sudo tee -a $MPD_CONF > /dev/null <<EOL

audio_output {
	type "alsa"
	name "TempoTec HD USB AUDIO"
	device "hw:1,0"
}

audio_output {
	type "alsa"
	name "iBasso-DC03-Pro"
	device "hw:1,0"
}
EOL
fi

# Restart MPD
sudo systemctl restart mpd
sudo systemctl status mpd
