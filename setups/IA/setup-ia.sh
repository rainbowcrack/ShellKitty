#!/bin/bash

# ================================================================
# AI Environment Setup Script
# Installs Python, PyTorch, TensorFlow, and AI graphics libraries
# ================================================================

set -e

echo "=============================================="
echo " AI Environment Setup Starting..."
echo "=============================================="

# Update system
echo "[1/6] Updating system..."
sudo apt-get update -y && sudo apt-get upgrade -y

# Install Python and essential build tools
echo "[2/6] Installing Python and tools..."
sudo apt-get install -y python3 python3-pip python3-venv build-essential cmake git

# Create a virtual environment
echo "[3/6] Creating Python virtual environment..."
if [ ! -d "$HOME/ai-env" ]; then
    python3 -m venv $HOME/ai-env
fi
source $HOME/ai-env/bin/activate

# Upgrade pip
pip install --upgrade pip setuptools wheel

# Install PyTorch (CPU version for compatibility)
echo "[4/6] Installing PyTorch..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install TensorFlow (CPU version)
echo "[5/6] Installing TensorFlow..."
pip install tensorflow

# Install AI graphics and visualization libraries
echo "[6/6] Installing visualization and data libraries..."
pip install matplotlib seaborn plotly scikit-learn pandas numpy jupyterlab

echo "=============================================="
echo " AI Environment Setup Completed!"
echo " To activate the environment, run:"
echo "   source ~/ai-env/bin/activate"
echo " Then you can run Jupyter Lab with: jupyter lab"
echo "=============================================="
