#!/bin/bash

set -e

echo "======================================="
echo "   Eyelock Environment Setup"
echo "======================================="

# Check if Python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Python3 not found. Installing..."

    if [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install -y python3
    elif [ -f /etc/redhat-release ]; then
        sudo dnf install -y python3
    elif [ -f /etc/arch-release ]; then
        sudo pacman -Sy --noconfirm python
    else
        echo "Unsupported distribution. Please install Python3 manually."
        exit 1
    fi
else
    echo "Python3 is already installed."
fi

echo "======================================="
echo "   Running Eyelock v1.0"
echo "======================================="

python3 eyelock.py
