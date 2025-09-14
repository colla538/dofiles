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
  grep -oE '^[[:space:]]*[-*]?[[:space:]]*([a-zA-Z0-9@._+-]+)' DEPENDENCIES.md | \
  sed -E 's/^[[:space:]]*[-*]?[[:space:]]*//' | while read -r pkg; do
    [[ -z "$pkg" ]] && continue
    [[ "$pkg" =~ ^(linux|base|base-devel|grub|systemd|glibc)$ ]] && continue
    if ! pacman -Qi "$pkg" &>/dev/null && ! yay -Qi "$pkg" &>/dev/null; then
      yay -S --needed --noconfirm "$pkg"
    fi
  done
fi

# 3. Stow configs (all dirs except .git and script/docs files)
if pacman -Qi stow &>/dev/null || sudo pacman -S --needed --noconfirm stow; then
  for dir in */; do
    case "$dir" in
      .git*/|*/ ) : ;;
      *)
        # Skip files like DEPENDENCIES.md or install.sh
        [[ -d "$dir" ]] && stow -v -t "$HOME" "$dir"
        ;;
    esac
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
