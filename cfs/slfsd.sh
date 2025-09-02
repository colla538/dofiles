#!/bin/bash

echo "🔍 Checking for installed i386 packages..."
i386_packages=$(dpkg --list | grep ':i386' | awk '{print $2}')

if [ -z "$i386_packages" ]; then
    echo "✅ No i386 packages found!"
else
    echo "🗑 Removing i386 packages..."
    sudo apt purge --autoremove -y $i386_packages
fi

echo "🔍 Checking if i386 architecture is still enabled..."
if dpkg --print-foreign-architectures | grep -q "i386"; then
    echo "🗑 Removing i386 architecture support..."
    sudo dpkg --remove-architecture i386
    echo "🔄 Updating package list..."
    sudo apt update
    echo "✅ i386 architecture removed successfully!"
else
    echo "✅ i386 architecture is already removed!"
fi

echo "🎯 System cleanup complete!"
