#!/bin/bash
set -e

echo "==================================="
echo "Verificando se o Docker está OK..."
echo "==================================="

if ! command -v docker &> /dev/null; then
  echo "Docker não encontrado! Instale o Docker antes de continuar."
  exit 1
fi

echo "=============================="
echo "Fazendo pull da imagem Debian"
echo "=============================="

docker pull debian || { echo "Falha ao puxar imagem Debian."; exit 1; }

echo "==================================="
echo "Rodando container Debian interativo"
echo "==================================="

docker run -it --name shellkitty_debian --rm debian bash -c "apt update && apt install -y neofetch && neofetch && bash"

echo ""
echo "==================================="
echo "Container encerrado. Containers ativos agora:"
docker ps
echo "==================================="