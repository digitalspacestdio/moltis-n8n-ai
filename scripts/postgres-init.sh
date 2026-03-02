#!/bin/sh
set -e

echo "Primary PostgreSQL database: ${POSTGRES_DB}"

create_db_if_missing() {
  db_name="$1"
  label="$2"

  if [ -n "${db_name}" ]; then
    echo "Ensuring ${label} database exists: ${db_name}"
    psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname postgres <<-EOSQL
      SELECT 'CREATE DATABASE "${db_name}"'
      WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${db_name}')\gexec
EOSQL
  fi
}

# LiteLLM backing store.
create_db_if_missing "${LITELLM_DB}" "LiteLLM"
# Baserow backing store.
create_db_if_missing "${BASEROW_DB}" "Baserow"
