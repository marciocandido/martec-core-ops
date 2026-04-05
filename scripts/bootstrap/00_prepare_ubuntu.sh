#!/bin/bash
set -e

echo "[BOOTSTRAP] Updating system..."
sudo apt update && sudo apt upgrade -y

echo "[BOOTSTRAP] Installing base packages..."
sudo apt install -y git curl wget unzip jq rsync tar pigz nano vim htop

echo "[BOOTSTRAP] Setting timezone..."
sudo timedatectl set-timezone America/Sao_Paulo

echo "[BOOTSTRAP] Done."