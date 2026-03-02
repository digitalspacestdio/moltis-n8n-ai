## Context

Current stack: OpenClaw (Node.js, npm) + n8n in Docker. OpenClaw runs `node:22-slim` with `npm install -g openclaw`, config in openclaw.json, gateway on 3456. n8n workflows are invoked via `http://n8n:5678/webhook/<path>`.

zeroclaw (Rust): single binary, ghcr.io/zeroclaw-labs/zeroclaw image, config.toml, gateway default 3000. Has `zeroclaw migrate openclaw` for memory; config format differs.

## Goals / Non-Goals

**Goals:**

- Replace OpenClaw service with zeroclaw in docker-compose
- Preserve port 3456 for zeroclaw gateway (minimize external config)
- Provide config.toml example with gateway + n8n webhook base
- Update all project docs to zeroclaw terminology and zeroclaw-labs/zeroclaw repo

**Non-Goals:**

- Migrating existing OpenClaw workspace/memory (user responsibility; `zeroclaw migrate openclaw` exists)
- Changing n8n service or workflows
- Adding new zeroclaw channels (Telegram, Discord, etc.)

## Decisions

1. **Image**: Use `ghcr.io/zeroclaw-labs/zeroclaw:latest`. Alternative: build from source in Dockerfile — rejected for simplicity; upstream image is maintained.

2. **Port**: Keep 3456 for zeroclaw gateway via `ZEROCLAW_GATEWAY_PORT=3456` (or config.toml gateway.port). Aligns with existing README/docs.

3. **Config mount**: Mount `config/zeroclaw.toml` (or `config.toml`) into `/zeroclaw-data/.zeroclaw/config.toml`. zeroclaw expects `HOME=/zeroclaw-data` and config at `$HOME/.zeroclaw/config.toml`.

4. **n8n integration**: zeroclaw uses `http_request` tool; no built-in n8n block like OpenClaw. Document n8n webhook URL (`http://n8n:5678/webhook`) in config or workspace prompt so agent can invoke workflows. Add to tools allowlist if needed.

5. **Volume**: `zeroclaw-data` replacing `openclaw-data`. Workspace at `/zeroclaw-data/workspace` or mount `./workspace` into it.

## Risks / Trade-offs

- [Config format change] → Provide clear zeroclaw.config.example.toml with comments mapping from openclaw.json
- [zeroclaw n8n not first-class] → Agent uses http_request; document in AGENTS.md / README
- [API key env name] → zeroclaw uses `API_KEY` or `ZEROCLAW_API_KEY`; align .env.template

## Migration Plan

1. Update docker-compose: service `zeroclaw`, image, volumes, env, command
2. Add config/zeroclaw.example.toml; remove or deprecate openclaw.example.json
3. Update README, AGENTS.md, .env.template, openspec/config.yaml
4. Rename volume openclaw-data → zeroclaw-data; users with existing data run `zeroclaw migrate openclaw` if needed
