#!/bin/bash
set -e

echo "[BOOTSTRAP] Installing PostgreSQL client..."
sudo apt install -y postgresql-client

echo "[BOOTSTRAP] PostgreSQL client installed."