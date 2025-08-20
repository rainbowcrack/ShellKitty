#!/bin/bash

clear
echo "Starting Docker environment verification..."

# +++ Funcao para instalar Docker em sistemas baseados em Debian/Ubuntu +++
instalar_docker() {
  echo "Installing Docker e Docker Compose..."
  sudo apt update
  sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

  sudo systemctl enable docker
  sudo systemctl start docker

  echo "Docker installed successfully!"
}

# +++ Verifica se Docker esta instalado +++
if ! command -v docker &> /dev/null; then
  echo "Docker not found."
  read -p "Do you want to install Docker now? (y/n): " instalar
  if [[ "$instalar" == "s" ]]; then
    instalar_docker
  else
    echo "Docker is necessary to run the project. Exiting..."
    exit 1
  fi
fi

# +++ Verifica se Docker Compose V2 esta disponivel +++
if ! docker compose version &> /dev/null; then
  echo "Docker Compose V2 not found."
  echo "Check if you have installed the latest version of Docker CLI with the embedded Compose plugin."
  exit 1
fi

echo "Docker and Compose are ready!"
echo ""

# +++ Menu principal +++
echo "================= SHELLKITTY Docker MENU ================="
echo "Choose an option:"
echo "1 - Start containers (reuse old images)"
echo "2 - Start containers (reconstruct images)"
echo "3 - Stop containers"
echo "4 - Stop and remove all containers (includes database)"
echo "5 - Stop and remove orphans (without deleting data)"
echo "6 - View active containers"
echo "7 - View all containers"
echo "8 - View logs aplication"
echo "0 - Exit"
echo "=========================================================="

read -p "Enter the option: " opcao

case $opcao in
  1)
    echo "Uploading containers with existing images..."
    docker compose up -d
    ;;
  2)
    echo "Rebuilding images and uploading containers..."
    docker compose up -d --build
    ;;
  3)
    echo "Stopping containers..."
    docker compose down
    ;;
  4)
    echo "This will erase all data (including the database)."
    read -p "Sure you want to continue? (s/n): " confirmacao
    if [[ "$confirmacao" == "s" ]]; then
      docker compose down --volumes --remove-orphans
    else
      echo "Action canceled."
    fi
    ;;
  5)
    echo "Removing orphaned containers (keeping the data)..."
    docker compose down --remove-orphans
    ;;
  6)
    echo "Active containers:"
    docker ps
    ;;
  7)
    echo "All containers (active and inactive):"
    docker ps -a
    ;;
  8)
    echo "Logs aplication (java-app):"
    docker logs java-app
    ;;
  0)
    echo "Exiting..."
    exit 0
    ;;
  *)
    echo "Invalid option. Please try again."
    ;;
esac
