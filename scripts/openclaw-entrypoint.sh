#!/usr/bin/env sh
set -eu

if [ -n "${TELEGRAM_BOT_TOKEN:-}" ]; then
  openclaw channels add --channel telegram --token "${TELEGRAM_BOT_TOKEN}" || true
fi

exec "$@"
