#!/bin/bash

echo "Atualizando pacotes..."
sudo apt update || { echo "Falha ao atualizar pacotes."; exit 1; }

echo "Instalando o Maven..."
sudo apt install -y maven || { echo "Erro ao instalar Maven."; exit 1; }

echo "Maven instalado. Versao:"
mvn -v || { echo "Maven nao esta funcionando."; exit 1; }

echo "Baixando Apache Spark..."
SPARK_VERSION="3.5.1"
HADOOP_VERSION="3"
SPARK_ARCHIVE="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"
SPARK_TGZ="${SPARK_ARCHIVE}.tgz"

wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_TGZ} -O /tmp/${SPARK_TGZ} || { echo "Falha ao baixar o Spark."; exit 1; }

echo "Extraindo Spark..."
tar -xzf /tmp/${SPARK_TGZ} -C $HOME || { echo "Falha ao extrair o Spark."; exit 1; }

echo "Testando Spark..."
$HOME/${SPARK_ARCHIVE}/bin/spark-shell --version || { echo "park nao esta funcionando corretamente."; exit 1; }

echo "Apache Spark instalado com sucesso. Versao:"
$HOME/${SPARK_ARCHIVE}/bin/spark-shell --version

echo "Testando Maven com projeto de exemplo..."
mkdir -p $HOME/maven-test && cd $HOME/maven-test
mvn archetype:generate -DgroupId=com.exemplo -DartifactId=teste -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false || {
    echo "❌ Maven falhou ao criar o projeto.";
    exit 1;
}

cd teste
mvn compile || { echo "Maven falhou ao compilar o projeto."; exit 1; }

echo "Teste Maven finalizado com sucesso."

echo "Todos os testes concluídos com sucesso!"
