#!/bin/bash

clear
echo "Iniciando verificacao do ambiente Minikube + Kubernetes..."

# +++ Funcao para instalar Minikube + kubectl (Debian/Ubuntu) +++
instalar_minikube() {
  echo "Instalando Minikube e kubectl..."

  sudo apt update -y
  sudo apt install -y curl apt-transport-https ca-certificates conntrack

  # Instala kubectl
  curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/

  # Instala Minikube
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
  rm minikube-linux-amd64

  echo "Minikube e kubectl instalados com sucesso!"
}

# +++ Verifica se o Minikube esta instalado +++
if ! command -v minikube &> /dev/null; then
  echo "Minikube nao encontrado."
  read -p "Deseja instalar o Minikube agora? (s/n): " instalar
  if [[ "$instalar" == "s" ]]; then
    instalar_minikube
  else
    echo "Minikube eh necessario para este menu. Saindo..."
    exit 1
  fi
fi

# +++ Verifica se o kubectl está instalado +++
if ! command -v kubectl &> /dev/null; then
  echo "kubectl não encontrado."
  echo "Voce precisa do kubectl para se comunicar com o cluster."
  exit 1
fi

# +++ Menu principal +++
while true; do
  echo ""
  echo "================= SHELLKITTY K8s MENU ================="
  echo "1 - Iniciar Minikube"
  echo "2 - Parar Minikube"
  echo "3 - Ver pods ativos"
  echo "4 - Ver todos os recursos (pods, services, deployments)"
  echo "5 - Remover um pod"
  echo "6 - Remover um deployment"
  echo "7 - Ver logs de um pod"
  echo "0 - Sair"
  echo "=========================================================="
  read -p "Digite a opcao desejada: " opcao

  case $opcao in
    1)
      echo "Iniciando Minikube..."
      minikube start
      ;;
    2)
      echo "Parando Minikube..."
      minikube stop
      ;;
    3)
      echo "Listando pods ativos..."
      kubectl get pods
      ;;
    4)
      echo "Todos os recursos:"
      kubectl get all
      ;;
    5)
      read -p "Digite o nome do pod a ser removido: " podname
      kubectl delete pod "$podname"
      ;;
    6)
      read -p "Digite o nome do deployment a ser removido: " deployname
      kubectl delete deployment "$deployname"
      ;;
    7)
      read -p "Digite o nome do pod para ver os logs: " logpod
      kubectl logs "$logpod"
      ;;
    0)
      echo "Saindo do menu Kubernetes..."
      break
      ;;
    *)
      echo "Opcao invalida. Tente novamente."
      ;;
  esac
done
