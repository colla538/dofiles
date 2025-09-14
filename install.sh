#!/usr/bin/env bash
set -euo pipefail

# 1. Install yay
if ! command -v yay &>/dev/null; then
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

# 2. Install packages from DEPENDENCIES.md
if [[ -f DEPENDENCIES.md ]]; then
  xargs -r yay -S --needed --noconfirm < DEPENDENCIES.md
fi

# 3. Stow configs (restow for idempotency)
if pacman -Qi stow &>/dev/null || sudo pacman -S --needed --noconfirm stow; then
  for dir in */; do
    [[ "$dir" =~ ^(\.git|yay)/$ ]] && continue
    [[ -d "$dir" ]] && stow --restow -v -t "$HOME" "$dir"
  done
fi

# 4. Install pipx and mov-cli stuff
if ! command -v pipx &>/dev/null; then
  sudo pacman -S --needed --noconfirm python-pipx
  pipx ensurepath
fi

if ! pipx list | grep -q mov-cli; then
  pipx install mov-cli
  pipx inject mov-cli mov-cli-youtube mov-cli-files
fi

