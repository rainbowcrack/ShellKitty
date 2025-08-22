#!/bin/bash

clear
echo "Starting verification of the Minikube + Kubernetes environment..."

# +++ Funcao para instalar Minikube + kubectl (Debian/Ubuntu) +++
instalar_minikube() {
  echo "Installing Minikube and kubectl..."

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

  echo "Minikube and kubectl installed successfully!"
}

# +++ Verifica se o Minikube esta instalado +++
if ! command -v minikube &> /dev/null; then
  echo "Minikube not found"
  read -p "Do you want to install Minikube now? (y/n): " instalar
  if [[ "$instalar" == "s" ]]; then
    instalar_minikube
  else
    echo "Minikube is necessary for this menu. Exiting..."
    exit 1
  fi
fi

# +++ Verifica se o kubectl está instalado +++
if ! command -v kubectl &> /dev/null; then
  echo "kubectl not found."
  echo "You need kubectl to communicate with the cluster."
  exit 1
fi

# +++ Menu principal +++
while true; do
  echo ""
  echo "================= SHELLKITTY K8s MENU ================="
  echo "1 - Start Minikube"
  echo "2 - Stop Minikube"
  echo "3 - View active pods"
  echo "4 - See all resources (pods, services, deployments)"
  echo "5 - Remove an pod"
  echo "6 - Remove an deployment"
  echo "7 - View logs of pod"
  echo "0 - Exit"
  echo "=========================================================="
  read -p "Enter the option: " opcao

  case $opcao in
    1)
      echo "Starting Minikube..."
      minikube start
      ;;
    2)
      echo "Stopping Minikube..."
      minikube stop
      ;;
    3)
      echo "Listening active pods..."
      kubectl get pods
      ;;
    4)
      echo "All resources:"
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
      echo "Exiting Kubernetes menu..."
      break
      ;;
    *)
      echo "Option not found. Try again."
      ;;
  esac
done
