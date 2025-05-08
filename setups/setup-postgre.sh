#!/bin/bash

# atualiza os pacotes e instala o PostgreSQL
echo "Atualiza os pacotes e baixa o PostgreSQL localmente..."
sudo apt update && sudo apt-get install -y postgresql postgresql-contrib || { echo "Falha na instalacao do PostgreSQL"; exit 1; }

# baixa a imagem oficial do Postgres via Docker
echo "Fazendo pull da imagem Docker do Postgres..."
docker pull postgres || { echo "Falha ao puxar a imagem do Docker"; exit 1; }

# executa comandos para configurar o PostgreSQL local como usuario 'postgres'
echo "Configurando banco de dados localmente via psql..."

sudo -u postgres psql <<EOF

-- Cria um user chamado 'admin' com senha
CREATE USER admin WITH PASSWORD '123';

-- Cria o banco de dados 'bancosimulador'
CREATE DATABASE bancosimulador;

-- Concedde todas as permissoes ao usuario 'admin'
GRANT ALL PRIVILEGES ON DATABASE bancosimulador TO admin;
EOF

echo "PostgreSQL local configurado com sucesso!"
