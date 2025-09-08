#!/bin/bash

echo
echo "[PACKAGE LISTER 2000]"
echo
echo "Choose package sorting type:"
echo "1) All"
echo "2) Explicit"
echo "3) Deps"
echo "4) Search 4 PKG size"
echo "5) Tree Package"
echo "6) Total size installed"
echo
read -rp " >> " choice

format_pkg() {
    pkg=$1
    pacman -Qi "$pkg" | awk -v pkg="$pkg" '
        /^Installed Size/ {
            size=$4; unit=$5
            if (unit=="B") size=size/1073741824
            else if (unit=="KiB") size=size/1048576
            else if (unit=="MiB") size=size/1024
            else if (unit=="GiB") size=size
            printf "%-30s %10.4f GB\n", pkg, size
        }'
}

if [[ $choice -eq 1 ]]; then
    read -rp "How many packages to show? " num
    pacman -Qq | while read -r pkg; do format_pkg "$pkg"; done | sort -k2 -nr | head -n "$num"

elif [[ $choice -eq 2 ]]; then
    read -rp "How many packages to show? " num
    pacman -Qqe | while read -r pkg; do format_pkg "$pkg"; done | sort -k2 -nr | head -n "$num"

elif [[ $choice -eq 3 ]]; then
    read -rp "How many packages to show? " num
    pacman -Qqd | while read -r pkg; do format_pkg "$pkg"; done | sort -k2 -nr | head -n "$num"

elif [[ $choice -eq 4 ]]; then
    read -rp "Enter package name to search: " search
    pacman -Qq | grep -i "$search" | while read -r pkg; do format_pkg "$pkg"; done | sort -k2 -nr

elif [[ $choice -eq 5 ]]; then
    read -rp "Enter package name for dependency tree: " pkg
    pactree -s "$pkg"

elif [[ $choice -eq 6 ]]; then
    total=$(pacman -Qi | awk '
        /^Installed Size/ {
            size=$4; unit=$5
            if (unit=="B") size=size/1073741824
            else if (unit=="KiB") size=size/1048576
            else if (unit=="MiB") size=size/1024
            else if (unit=="GiB") size=size
            sum+=size
        } END {printf "%.2f GB", sum}')
    echo "Total installed size: $total"

else
    echo "Invalid choice."
fi

