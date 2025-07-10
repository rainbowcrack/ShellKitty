#!/bin/bash
set -e

echo "============================"
echo "Checking MySQL locally..."
echo "============================"

if ! command -v mysql &> /dev/null; then
    echo "MySQL is not installed. Installing..."
    sudo apt update
    sudo apt install -y mysql-server || { echo "Failed to install MySQL"; exit 1; }
    sudo systemctl start mysql
    sudo systemctl enable mysql
else
    echo "MySQL is already installed."
fi

echo "============================"
echo "Checking for Docker..."
echo "============================"

if command -v docker &> /dev/null; then
    echo "Docker is installed. Pulling MySQL image..."
    docker pull mysql || { echo "Failed to pull MySQL image"; exit 1; }
else
    echo "Docker is not installed. Skipping Docker part."
fi

echo "============================"
echo "Configuring local MySQL..."
echo "============================"

DB_USER="admin"
DB_PASS="password123"
DB_NAME="bankssimulator"

sudo mysql -u root <<EOF
-- Create user if not exists
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
-- Create database if not exists
CREATE DATABASE IF NOT EXISTS $DB_NAME;
-- Grant privileges
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "Local MySQL configured successfully!"