#!/bin/bash

# Colors
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Configurations
BACKEND_PORT=4567
FRONTEND_PORT=3000
POSTGRES_PORT=5432
POSTGRES_CONTAINER_NAME="my_postgres"
BACKEND_TEST_ROUTE="http://localhost:${BACKEND_PORT}/api/status"
FRONTEND_TEST_ROUTE="http://localhost:${FRONTEND_PORT}"

# install nmap
sudo apt update && sudo apt upgrade -y
sudo apt install -y nmap

# Function to check if a port is listening
check_port() {
    local PORT=$1
    nc -z localhost $PORT
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Port $PORT is open.${RESET}"
    else
        echo -e "${RED}Port $PORT is not responding.${RESET}"
    fi
}

# Function to check a route using curl
check_route() {
    local URL=$1
    local EXPECTED_STATUS=${2:-200}
    local STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
    if [ "$STATUS" -eq "$EXPECTED_STATUS" ]; then
        echo -e "${GREEN}Route $URL responded with status $STATUS.${RESET}"
    else
        echo -e "${RED}Route $URL responded with status $STATUS (expected $EXPECTED_STATUS).${RESET}"
    fi
}

echo "Checking running Docker containers..."
docker ps

# Checking ports
echo -e "\nChecking local ports..."
check_port $BACKEND_PORT
check_port $FRONTEND_PORT
check_port $POSTGRES_PORT

# Checking routes
echo -e "\nChecking HTTP routes..."
check_route $BACKEND_TEST_ROUTE
check_route $FRONTEND_TEST_ROUTE

# Checking PostgreSQL
echo -e "\nChecking PostgreSQL..."
if docker ps --format '{{.Names}}' | grep -q "^${POSTGRES_CONTAINER_NAME}$"; then
    docker exec $POSTGRES_CONTAINER_NAME pg_isready > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}PostgreSQL is accepting connections.${RESET}"
    else
        echo -e "${RED}PostgreSQL is not accepting connections.${RESET}"
    fi
else
    echo -e "${RED}PostgreSQL container '${POSTGRES_CONTAINER_NAME}' is not running.${RESET}"
fi