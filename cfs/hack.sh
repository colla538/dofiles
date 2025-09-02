#!/bin/bash

# Fake Hacking Script
clear
echo "Initializing hacking sequence..."
sleep 2
echo "Bypassing security firewall..."
sleep 2
echo "Accessing target system..."
sleep 2
echo "Downloading files..."

for i in {1..100}; do
    echo -ne "\rDownloading: $i%"
    sleep 0.05
done

echo -e "\nDownload complete!"
sleep 1
echo "Injecting malware..."
sleep 2
echo "Gaining root access..."
sleep 2

echo "root@anonymous:~# Access Granted!"
sleep 1

while true; do
    echo -n "root@anonymous:~# "
    read -r cmd
    case "$cmd" in
        "exit")
            echo "Closing connection..."
            sleep 2
            exit
            ;;
        "ls")
            echo "root  bin  boot  dev  etc  home  lib  mnt  opt  proc  sys  tmp  >
            ;;
        "whoami")
            echo "Anonymous Hacker"
            ;;
        "hack fb")
            echo "Hacking Facebook... Please wait..."
            sleep 3
            echo "Success! Access token: 5A7B8C9D0E"
            ;;
        "hack google")
            echo "Hacking Google... Please wait..."
            sleep 3
            echo "Access denied! System countermeasure activated!"
            ;;
 	*)
            echo "Command not recognized."
            ;;
    esac
done
