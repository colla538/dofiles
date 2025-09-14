#!/bin/bash

# clone yay if not installed
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

# separate pacman and AUR packages using yay -Si
PACMAN_PKGS=$(cat DEPENDENCIES.md | while read pkg; do
  repo=$(yay -Si "$pkg" 2>/dev/null | awk -F': ' '/^Repository/{print $2}')
  [[ "$repo" == "core" || "$repo" == "extra" || "$repo" == "community" || "$repo" == "multilib" ]] && echo "$pkg"
done)

AUR_PKGS=$(cat DEPENDENCIES.md | while read pkg; do
  repo=$(yay -Si "$pkg" 2>/dev/null | awk -F': ' '/^Repository/{print $2}')
  [[ "$repo" == "AUR" ]] && echo "$pkg"
done)

# install pacman packages
if [ -n "$PACMAN_PKGS" ]; then
  sudo pacman -S --needed --noconfirm $PACMAN_PKGS
fi

# install aur packages
if [ -n "$AUR_PKGS" ]; then
  echo "AUR packages detected: $AUR_PKGS"
  read -p "Do you want to install them? [y/N]: " choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    yay -S --needed $AUR_PKGS
  fi
fi

# stow configs
if command -v stow &>/dev/null; then
  stow -d dofiles -t ~ */
else
  echo "stow not found, skipping config stow"
fi

# install pipx and mov-cli packages
if ! command -v pipx &>/dev/null; then
  python -m pip install --user pipx
  python -m pipx ensurepath
fi

pipx install mov-cli
pipx inject mov-cli mov-cli-youtube mov-cli-files

