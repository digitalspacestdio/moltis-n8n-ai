#!/usr/bin/env bash
set -euo pipefail

volumes=(
  "moltis-n8n-ai_traefik-letsencrypt"
  "moltis-n8n-ai_postgres-data"
  "moltis-n8n-ai_moltis-config"
  "moltis-n8n-ai_moltis-data"
  "moltis-n8n-ai_n8n-data"
  "moltis-n8n-ai_baserow-media-data"
)

for vol in "${volumes[@]}"; do
  docker volume create "${vol}" >/dev/null
  echo "OK ${vol}"
done
