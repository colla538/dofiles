#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <file1> <file2> <output_file>"
    exit 1
fi

# Get input files and output file from arguments
file1="$1"
file2="$2"
output_file="$3"

# Combine file1 and file2, process the text, and save to the specified output file
cat "$file1" "$file2" | sed 's/^[0-9]\+\.\s*//' | sed 's/([^)]*)//g' | sort | uniq | nl -w1 -s'. ' > "$output_file"

echo "Processing complete. Output written to $output_file"
