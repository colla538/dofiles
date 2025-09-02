#!/bin/bash

# Detect the package manager
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt install -y"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
else
    echo "Unsupported package manager. Exiting."
    exit 1
fi

# Define available Wine packages
OPTIONS=(
    "Wine (Basic 64-bit)"
    "Wine 32-bit Support (Multiarch)"
    "Wine Multilib (Arch Only)"
    "Winetricks"
    "All of the above"
)

# Display options
echo "Select the Wine components you want to install (e.g., 1 2 5):"  
for i in "${!OPTIONS[@]}"; do  
    echo "$((i+1)). ${OPTIONS[$i]}"
  
done

echo -n "Enter your choices (space-separated numbers): "  
read -r -a choices

for choice in "${choices[@]}"; do
    case $choice in
        1) 
            $INSTALL_CMD wine wine64
            ;;
        2) 
            if [ "$PKG_MANAGER" = "apt" ]; then
                sudo dpkg --add-architecture i386 && sudo apt update
                $INSTALL_CMD wine32
            elif [ "$PKG_MANAGER" = "pacman" ]; then
                echo "Wine 32-bit support is included in multilib on Arch. Choose option 3."
            fi
            ;;
        3) 
            if [ "$PKG_MANAGER" = "pacman" ]; then
                $INSTALL_CMD wine-multilib
            else
                echo "This option is only available for Arch Linux."
            fi
            ;;
        4) 
            $INSTALL_CMD winetricks
            ;;
        5) 
            if [ "$PKG_MANAGER" = "apt" ]; then
                sudo dpkg --add-architecture i386 && sudo apt update
                $INSTALL_CMD wine wine64 wine32 winetricks
            elif [ "$PKG_MANAGER" = "pacman" ]; then
                $INSTALL_CMD wine wine-multilib winetricks
            fi
            ;;
        *) 
            echo "Invalid choice: $choice. Skipping."
            ;;
    esac

done

echo "Installation complete!"
