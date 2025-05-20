#!/bin/bash

clear
echo "Iniciando verificacao do ambiente Docker..."

# +++ Funcao para instalar Docker em sistemas baseados em Debian/Ubuntu +++
instalar_docker() {
  echo "Instalando Docker e Docker Compose..."
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

  echo "Docker instalado com sucesso!"
}

# +++ Verifica se Docker esta instalado +++
if ! command -v docker &> /dev/null; then
  echo "Docker nao encontrado."
  read -p "Deseja instalar o Docker agora? (s/n): " instalar
  if [[ "$instalar" == "s" ]]; then
    instalar_docker
  else
    echo "Docker eh necessario para rodar o projeto. Saindo..."
    exit 1
  fi
fi

# +++ Verifica se Docker Compose V2 esta disponivel +++
if ! docker compose version &> /dev/null; then
  echo "Docker Compose V2 nao encontrado (comando 'docker compose')."
  echo "Verifique se voce instalou a versao mais recente do Docker CLI com plugin Compose embutido."
  exit 1
fi

echo "Docker e Compose estao prontos!"
echo ""

# +++ Menu principal +++
echo "Escolha uma opcao:"
echo "1 - Iniciar containers (reaproveitar imagens antigas)"
echo "2 - Iniciar containers (reconstruir imagens)"
echo "3 - Parar containers"
echo "4 - Parar e apagar tudo (inclui dados do banco)"
echo "5 - Parar e remover orfaos (sem apagar dados)"
echo "6 - Ver containers ativos"
echo "7 - Ver todos os containers"
echo "8 - Ver logs da aplicacao"
echo "0 - Sair"
echo ""

read -p "Digite a opcao desejada: " opcao

case $opcao in
  1)
    echo "Subindo containers com imagens existentes..."
    docker compose up -d
    ;;
  2)
    echo "Reconstruindo imagens e subindo containers..."
    docker compose up -d --build
    ;;
  3)
    echo "Parando containers..."
    docker compose down
    ;;
  4)
    echo "Isso vai apagar TODOS os dados (incluindo o banco)."
    read -p "Tem certeza? (s/n): " confirmacao
    if [[ "$confirmacao" == "s" ]]; then
      docker compose down --volumes --remove-orphans
    else
      echo "Acao cancelada."
    fi
    ;;
  5)
    echo "Removendo containers orfaos (mantendo os dados)..."
    docker compose down --remove-orphans
    ;;
  6)
    echo "Containers ativos:"
    docker ps
    ;;
  7)
    echo "Todos os containers (ativos e inativos):"
    docker ps -a
    ;;
  8)
    echo "Logs da aplicacao (java-app):"
    docker logs java-app
    ;;
  0)
    echo "Saindo..."
    exit 0
    ;;
  *)
    echo "Opcao invalida."
    ;;
esac
