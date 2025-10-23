#!/usr/bin/env bash
set -euo pipefail
until (/usr/bin/mc alias set local http://minio:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" 2>/dev/null); do
  echo "Waiting for MinIO..." && sleep 2
done
/usr/bin/mc mb -p local/bronze || true
/usr/bin/mc mb -p local/silver || true
/usr/bin/mc mb -p local/gold || true
/usr/bin/mc anonymous set download local/bronze || true
echo "Buckets ready: bronze, silver, gold"
tail -f /dev/null