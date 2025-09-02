#!/bin/bash

clear
echo -e "\n\033[1;36mYT-DLP Tool (Bash Edition)\033[0m"

# === Check for txt file or ask manually ===
LINK_FILE="$1"
LINKS=()

if [[ -z "$LINK_FILE" ]]; then
    read -rp "Paste YouTube link: " YT_LINK
    if [[ -z "$YT_LINK" ]]; then
        echo "❌ No link provided. Exiting."
        exit 1
    fi
    LINKS+=("$YT_LINK")
else
    if [[ ! -f "$LINK_FILE" ]]; then
        echo "❌ File not found: $LINK_FILE"
        exit 1
    fi
    mapfile -t LINKS < "$LINK_FILE"
fi

# === Select mode ===
while true; do
    read -rp "Mode? [a]udio / [v]ideo: " MODE
    MODE=$(echo "$MODE" | tr '[:upper:]' '[:lower:]')
    [[ "$MODE" == "a" || "$MODE" == "v" ]] && break
done

# === Ask for output pattern ===
read -rp "Output filename pattern [default: %(title)s.%(ext)s]: " PATTERN
PATTERN=${PATTERN:-"%(title)s.%(ext)s"}

# === Audio settings ===
if [[ "$MODE" == "a" ]]; then
    echo -e "\nAudio Format:"
    echo "1) mp3"
    echo "2) m4a"
    echo "3) wav"
    read -rp "Choose format [1-3]: " FMT_CHOICE

    case "$FMT_CHOICE" in
        1) AUDIO_FMT="mp3" ;;
        2) AUDIO_FMT="m4a" ;;
        3) AUDIO_FMT="wav" ;;
        *) AUDIO_FMT="mp3" ;;
    esac

    read -rp "Audio quality (0=best, 9=worst) [default: 0]: " AUDIO_Q
    AUDIO_Q=${AUDIO_Q:-0}
fi

# === Loading bar ===
function loading_bar() {
    BAR=""
    for ((i=0; i<=20; i++)); do
        BAR+="#"
        clear
        echo -e "\033[1;32mStarting download...\033[0m"
        echo -ne "[$BAR$(printf ' %.0s' $(seq $((20 - i))))]\n"
        sleep 0.05
    done
}

# === Run yt-dlp ===
for LINK in "${LINKS[@]}"; do
    [[ -z "$LINK" ]] && continue
    loading_bar

    if [[ "$MODE" == "a" ]]; then
        yt-dlp -x \
            --audio-format "$AUDIO_FMT" \
            --audio-quality "$AUDIO_Q" \
            --add-metadata \
            --embed-metadata \
            -o "$PATTERN" \
            "$LINK"
    else
        yt-dlp \
            -S vcodec:h264 \
            -S acodec:mp4a \
            --add-metadata \
            --embed-metadata \
            -o "$PATTERN" \
            "$LINK"
    fi
done

echo -e "\n✅ Done!"
