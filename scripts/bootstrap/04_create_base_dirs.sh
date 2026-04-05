#!/bin/bash
set -e

BASE=${BACKUP_ROOT:-/opt/backups/martec-core}

echo "[BOOTSTRAP] Creating base directories..."

sudo mkdir -p $BASE
sudo mkdir -p $BASE/postgres
sudo mkdir -p $BASE/qdrant
sudo mkdir -p $BASE/files
sudo mkdir -p $BASE/logs

echo "[BOOTSTRAP] Directories created at $BASE"