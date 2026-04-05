#!/bin/bash
set -e

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=${BACKUP_ROOT:-/opt/backups/martec-core}/postgres
mkdir -p "$BACKUP_DIR"

FILE="$BACKUP_DIR/db_$DATE.dump"

echo "[BACKUP] Running pg_dump..."
pg_dump -h "$PGHOST" -U "$PGUSER" -F c -b -v -f "$FILE" "$PGDATABASE"

echo "[BACKUP] Generating checksum..."
sha256sum "$FILE" > "$FILE.sha256"

echo "[BACKUP] Done: $FILE"