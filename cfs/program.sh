#!/bin/bash

# Prompt user for directory
read -p "Enter the directory to search in: " directory

# Check if the directory exists
if [[ ! -d "$directory" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Prompt user for the word to search
read -p "Enter the word to search for: " word

# Search for the word in text files only
# -r: Recursive
# -i: Case-insensitive search
# -n: Show line numbers
# --color=always: Highlight matches
grep -rni --color=always "$word" "$directory" --include=\*.txt
