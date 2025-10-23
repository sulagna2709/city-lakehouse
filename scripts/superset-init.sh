#!/usr/bin/env bash
set -euo pipefail
export FLASK_APP=superset
superset db upgrade
superset fab create-admin \
  --username "${SUPERSET_ADMIN_USER:-admin}" \
  --firstname "${SUPERSET_ADMIN_FIRST:-Admin}" \
  --lastname "${SUPERSET_ADMIN_LAST:-User}" \
  --email "${SUPERSET_ADMIN_EMAIL:-admin@example.com}" \
  --password "${SUPERSET_ADMIN_PWD:-supersecret}" || true
superset init
echo "Superset ready at http://localhost:8088"