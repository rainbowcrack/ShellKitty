#!/bin/bash
set -e

echo "==================================="
echo " Verificando imagem do Debian..."
echo "==================================="

# Verifica se imagem Debian ja foi baixada
if ! docker image inspect debian:latest &>/dev/null; then
  echo "Imagem Debian nao encontrada. Baixando agora..."
  docker pull debian
else
  echo "Imagem Debian ja esta disponivel localmente."
fi

echo "============================================"
echo " Iniciando container com ambiente Debian..."
echo "============================================"

docker run -it \
  --name shellkitty_kali_sim \
  --rm \
  --hostname shellkitty-kali \
  --cap-add=ALL \
  --security-opt seccomp=unconfined \
  debian bash -c "
    apt update &&
    apt install -y sudo git python3 curl gnupg software-properties-common &&
    echo 'Instalando Katoolin...' &&
    git clone https://github.com/LionSec/katoolin.git &&
    cp katoolin/katoolin.py /usr/bin/katoolin &&
    chmod +x /usr/bin/katoolin &&
    echo 'Katoolin instalado! Iniciando...' &&
    katoolin
  "

echo ""
echo "=================================================="
echo " Ambiente encerrado (emulacao de falso kali linux)"
echo "Containers ativos agora:"
docker ps
echo "=================================================="
