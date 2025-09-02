#!/bin/bash

# Prompt the user to enter the directory where music files are stored
read -rp "Enter the directory containing music files: " directory

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist."
    exit 1
fi

# Prompt the user to enter the output file location
read -rp "Enter the output text file path (e.g., /home/user/song_list.txt): " output_file

# Confirm the chosen paths
echo "Music directory: $directory"
echo "Output file: $output_file"
read -rp "Proceed? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "Aborted."
    exit 1
fi

# Check if exiftool is installed
if ! command -v exiftool &> /dev/null; then
    echo "Error: 'exiftool' is not installed."
    echo "Please install it using:"
    echo "  - Linux (Debian/Ubuntu): sudo apt install libimage-exiftool-perl"
    echo "  - Mac (Homebrew): brew install exiftool"
    echo "  - Windows: Download from https://exiftool.org/"
    exit 1
fi

# Temporary file to store song list
temp_file=$(mktemp)

# Loop through all audio files in the directory
find "$directory" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.ogg" \) | while read -r file; do
    # Extract song title and artist
    title=$(exiftool -Title -s3 "$file")
    artist=$(exiftool -Artist -s3 "$file")

    # If metadata is missing, use filename as fallback
    if [[ -z "$title" ]]; then
        title=$(basename "$file" | sed 's/\.[^.]*$//')  # Remove file extension
    fi
    if [[ -z "$artist" ]]; then
        artist="Unknown Artist"
    fi

    # Format as "Song - Artist"
    echo "$title - $artist" >> "$temp_file"
done

# Sort the songs alphabetically, number them, and save to the output file
sort "$temp_file" | nl -w1 -s'. ' > "$output_file"

# Clean up temporary file
rm "$temp_file"

echo "Metadata extraction and sorting complete."
echo "The sorted list has been saved to: $output_file"
