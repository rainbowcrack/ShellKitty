#!/bin/bash
set -e

IMAGEM="debian"
CONTAINER_NAME="shellkitty_dev"
PASTA_ATUAL="$(pwd)"
PASTA_DESTINO="/root/projeto"

echo "==================================="
echo "🐳 Verificando imagem do Debian..."
echo "==================================="

if ! docker image inspect $IMAGEM:latest &>/dev/null; then
  echo "📥 Imagem Debian não encontrada. Baixando agora..."
  docker pull $IMAGEM
else
  echo "✅ Imagem Debian já está disponível."
fi

echo "=============================================="
echo "🚀 Iniciando container com projeto montado..."
echo "=============================================="

docker run -it --rm \
  --name "$CONTAINER_NAME" \
  --hostname shellkitty-dev \
  --cap-add=ALL \
  --security-opt seccomp=unconfined \
  -v "$PASTA_ATUAL:$PASTA_DESTINO" \
  $IMAGEM bash -c "
    apt update &&
    apt install -y sudo git curl neofetch &&
    echo '✅ Projeto montado em $PASTA_DESTINO' &&
    echo '🖥️  Informações do sistema simulado:' &&
    neofetch &&
    cd $PASTA_DESTINO &&
    bash
  "

echo ""
echo "🧹 Container encerrado. Projeto não foi alterado localmente."
