#!/bin/bash

set -e

echo "============================"
echo "Checking PostgreSQL locally"
echo "============================"

# Check if PostgreSQL is installed
# saida do stdout e stderr (&> /dev/null) para o buraco negro do linux 
if ! command -v psql &> /dev/null; then
    echo "PostgreSQL not found. Installing..."
    sudo apt update
    sudo apt-get install -y postgresql postgresql-contrib || { echo "PostgreSQL installation failed"; exit 1; }
else
    echo "PostgreSQL is already installed."
fi

echo "============================"
echo "Checking for Docker"
echo "============================"

if command -v docker &> /dev/null; then
    echo "Docker is installed. Pulling PostgreSQL image..."
    docker pull postgres || { echo "Failed to pull Docker image"; exit 1; }
else
    echo "Docker is not installed. Skipping Docker part."
fi

echo "============================"
echo "Configuring local PostgreSQL"
echo "============================"

sudo -u postgres psql <<EOF

-- Create user 'admin' with password
DO \$\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'admin'
   ) THEN
      CREATE ROLE admin WITH LOGIN PASSWORD 'password123';
   END IF;
END
\$\$;

-- Create database 'bankssimulator' if it doesn't exist
DO \$\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_database WHERE datname = 'bankssimulator'
   ) THEN
      CREATE DATABASE bankssimulator;
   END IF;
END
\$\$;

GRANT ALL PRIVILEGES ON DATABASE bankssimulator TO admin;

EOF

echo "Local PostgreSQL configured successfully!"
