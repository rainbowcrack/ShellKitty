#!/bin/bash
set -e

echo "==================================="
echo "Checking if Docker is OK..."
echo "==================================="

if ! command -v docker &> /dev/null; then
  echo "Docker not found! Please install Docker before continuing."
  exit 1
fi

echo "=============================="
echo "Pull Debian image"
echo "=============================="

docker pull debian || { echo "Failed to pull Debian image."; exit 1; }

echo "========================================"
echo "Running an interactive Debian container"
echo "========================================"

docker run -it --name shellkitty_debian --rm debian bash -c "apt update && apt install -y neofetch && neofetch && bash"

echo ""
echo "==========================================="
echo "Container closed. Active containers now: "
docker ps
echo "=========================================="