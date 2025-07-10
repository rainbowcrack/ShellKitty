#!/bin/bash

set -e 

echo "========================"
echo "Checking for MariaDB..."
echo "========================"

if ! command -v mysql &> /dev/null; then
    echo "MariaDB is not installed. Installing..."
    sudo apt update
    sudo apt install -y mariadb-server || {echo "Failed to install MariaDB"; exit 1;}
    sudo systemctl start mariadb
    sudo systemctl enable mariadb
else
    echo "MariaDB is already installed."
fi

echo "========================"
echo "Checking for Docker..."
echo "========================"

if command -v docker &> /dev/null; then
    echo "Docker is installed. Pulling MariaDB image..."
    docker pull mariadb || {echo "Failed to pull MariaDB image"; exit 1;}
else 
    echo "Docker is not installed. Installing..."
    sudo apt install -y docker.io || {echo "Failed to install Docker"; exit 1;}
    echo "Docker is installed."
fi

echo "============================"
echo "Configuring local MariaDB..."
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

echo "Local MariaDB configured successfully!"