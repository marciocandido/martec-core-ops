#!/bin/bash
set -e

echo "[BOOTSTRAP] Installing rclone..."
curl https://rclone.org/install.sh | sudo bash

echo "[BOOTSTRAP] rclone installed."