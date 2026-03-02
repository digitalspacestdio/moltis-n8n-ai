# moltis-n8n-ai — AI Agent Guide

Self-hosted AI automation stack with `moltis`, `litellm`, and `n8n`.

## Current Architecture

- Active gateway: `moltis` (`ai-stack-moltis-gateway`)
- LLM proxy: `litellm` (`ai-stack-litellm`)
- Workflow engine: `n8n` (`ai-stack-n8n-workflows`)
- Reverse proxy/TLS: `traefik` (`ai-stack-traefik`)
- Database: `postgres` (`ai-stack-postgres`)
- Baserow: `baserow-*` (`ai-stack-baserow-web-frontend`, `ai-stack-baserow-backend`, `ai-stack-baserow-redis`)
- Logs UI: `dozzle` (`ai-stack-dozzle`)
- Docker network: `ai-stack`

## Services And Access

- `traefik`
- External ports: `80`, `443`
- Public URLs:
- `https://${PROXY_DOMAIN}/` (moltis)
- `https://${PROXY_DOMAIN}/llm` (litellm)
- `https://${PROXY_DOMAIN}/n8n/` (n8n)
- `https://${PROXY_DOMAIN}/dozzle/` (dozzle)
- `https://${PROXY_DOMAIN}/traefik/` (traefik dashboard)
- `https://${BASEROW_DOMAIN}/` (baserow)
- Dashboard/API currently without Basic Auth middleware

- `moltis` image
- Runtime image: `ghcr.io/digitalspacestdio/moltis-n8n-ai-moltis:latest`
- Container command: `moltis --no-tls --log-level info`

- `postgres`
- Internal only: `5432`
- Volumes: `postgres-data`
- Init: `scripts/postgres-init.sh`

- `baserow`
- Public via Traefik: `https://${BASEROW_DOMAIN}/`
- Volume: `baserow-media-data`
- Internal services: `baserow-web-frontend` (`:3000`), `baserow-backend` (`:8000`)

- `litellm`
- Internal only in Docker network
- Internal URL for containers: `http://litellm/llm`
- Public URL via Traefik: `https://${PROXY_DOMAIN}/llm`
- Env: `LITELLM_MASTER_KEY=${LITELLM_API_KEY}`, `SERVER_ROOT_PATH=/llm`
- DB: `${LITELLM_DB}` in Postgres

- `moltis`
- Internal only in Docker network (Traefik routes to it)
- Config mounts:
- `./config/moltis.toml:/root/.config/moltis/moltis.toml`
- `./hooks:/root/.moltis/hooks`
- `./workspace:/root/.moltis/workspace`
- Env: `OPENAI_API_KEY=${LITELLM_API_KEY}`, `MOLTIS_PASSWORD`
- Depends on: `litellm`, `n8n`

- `n8n`
- Internal only in Docker network (Traefik route `/n8n/`)
- Uses Postgres backend (`DB_TYPE=postgresdb`)
- Volumes: `n8n-data`, `./workflows`

- `dozzle`
- Internal only in Docker network (Traefik route `/dozzle/`)
- Read-only Docker socket mount

## Disabled Services In Compose

- `openclaw` is disabled (commented out).
- `bifrost` is disabled (commented out).

## Key Config Files

- `.env` (from `.env.template`)
- `docker-compose.yml`
- `scripts/create-external-volumes.sh` (pre-create external named volumes)
- `config/moltis.toml`
- `DEPLOY.md` (clean-server deployment runbook)
- `workflows/*.json`

## Moltis Model Routing

- Moltis uses LiteLLM via OpenAI-compatible endpoint.
- `OPENAI_API_KEY` in `moltis` is set from `LITELLM_API_KEY`.
- LiteLLM internal endpoint for containers: `http://litellm/llm`.

## Workflow Conventions

- Workflows are stored in `workflows/*.json` (n8n exports).
- Webhook invocation from moltis tools:
- `POST http://n8n:5678/webhook/<path>`
- Examples: `/webhook/ripr-gpt`, `/webhook/ripr-gemini`

## Dev Environment

- Always try `docker compose` first.
- Use `docker-compose` only as fallback.
- Bring up stack:
```bash
cp .env.template .env
./scripts/create-external-volumes.sh
docker compose up -d
```
- Useful logs:
```bash
docker compose logs -f moltis litellm n8n
```

## Validation

- Validate compose:
```bash
docker compose config
```
- Verify services:
```bash
docker compose ps
docker compose logs --tail=100 moltis litellm n8n
```
- Verify LiteLLM reachability from moltis:
```bash
docker compose exec -T moltis sh -lc 'wget -qO- http://litellm/llm/health || true'
```

## Domain Routing Rule

- Prefer dedicated hostnames over subpaths for UI services.
- Current dedicated domains:
- `BASEROW_DOMAIN` for Baserow.

## User Bootstrap Rule

- Do not manually create application users by default.
- First use the app's native installation/signup bootstrap page when it exists (common for first-run setup).
- Create users manually (CLI/shell/API) only if the application explicitly supports that flow and there is no suitable install/signup bootstrap flow for the task.

## OpenSpec

- Changes in `openspec/changes/`
- Commands: `/opsx-new`, `/opsx-ff`, `/opsx-apply`, `/opsx-archive`, `/opsx-verify`
- Config: `openspec/config.yaml`
