#!/bin/bash

set -e  # Exit the script if any command fails

echo "===================="
echo "Updating packages"
echo "===================="
sudo apt update || { echo "Failed to update packages"; exit 1; }

echo "===================="
echo "Checking Java..."
echo "===================="

if ! command -v java &> /dev/null; then
    echo "Java is not installed. Installing..."
    sudo apt install -y default-jdk || { echo "Failed to install Java"; exit 1; }
else
    echo "Java is already installed."
fi

echo "Java version:"
java -version

echo "===================="
echo "Installing Maven..."
echo "===================="
sudo apt install -y maven || { echo "Failed to install Maven"; exit 1; }

echo "Maven installed. Version:"
mvn -v

echo "=============================="
echo "Downloading Apache Spark..."
echo "=============================="
SPARK_VERSION="3.5.1"
HADOOP_VERSION="3"
SPARK_ARCHIVE="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"
SPARK_TGZ="${SPARK_ARCHIVE}.tgz"
SPARK_DIR="$HOME/spark"

mkdir -p "$SPARK_DIR"

wget "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_TGZ}" -O "/tmp/${SPARK_TGZ}" || { echo "Failed to download Spark."; exit 1; }

echo "Extracting Spark to $SPARK_DIR..."
tar -xzf "/tmp/${SPARK_TGZ}" -C "$SPARK_DIR" || { echo "Failed to extract Spark"; exit 1; }

SPARK_PATH="${SPARK_DIR}/${SPARK_ARCHIVE}"

echo "=============================="
echo "Testing Spark installation..."
echo "=============================="
"$SPARK_PATH/bin/spark-shell" --version || { echo "Spark is not installed correctly"; exit 1; }

echo "Apache Spark installed successfully. Version:"
"$SPARK_PATH/bin/spark-shell" --version

echo "===================================="
echo "Testing Maven with sample project..."
echo "===================================="
MAVEN_TEST_DIR="$HOME/maven-test"

mkdir -p "$MAVEN_TEST_DIR"
cd "$MAVEN_TEST_DIR"

mvn archetype:generate -DgroupId=com.example -DartifactId=test-project -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false || {
    echo "Maven failed to create the project.";
    exit 1;
}

cd test-project
mvn compile || { echo "Maven failed to compile the project."; exit 1; }

echo "Script completed successfully!"
