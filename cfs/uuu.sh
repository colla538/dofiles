#!/bin/bash


while true; do
  read -p "Enter text: " text
  while true; do
    echo -n "$text"
      # Super fast, but still slightly perceptible
    read -t 0.001 -n 1 key && break  # Allows breaking out with any key press
  done
done
