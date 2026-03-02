## Why

Migrate from OpenClaw (Node.js) to zeroclaw (Rust) to benefit from zeroclaw's smaller footprint, faster startup, and lower resource usage while preserving n8n webhook integration. The current stack uses OpenClaw as the AI agent gateway; zeroclaw offers a drop-in replacement with similar gateway semantics.

## What Changes

- Replace OpenClaw Docker service with zeroclaw (ghcr.io/zeroclaw-labs/zeroclaw)
- Migrate config: openclaw.json → config.toml (zeroclaw TOML format)
- Update volumes: `~/.openclaw` → `~/.zeroclaw`; workspace layout unchanged
- Use zeroclaw gateway on port 3456 (match existing stack port for minimal changes)
- Update all docs, README, AGENTS.md, .env.template to reference zeroclaw
- **BREAKING**: Config schema changes (JSON → TOML); users must migrate config

## Capabilities

### New Capabilities

- `zeroclaw-gateway`: zeroclaw runs as Docker service with gateway on port 3456, n8n webhook base configured
- `config-migration`: Config migration path from openclaw.json to zeroclaw config.toml

### Modified Capabilities

_None — no existing specs._

## Impact

- docker-compose.yml: service name, image, volumes, command, env vars
- config/: replace openclaw.example.json with zeroclaw config example
- README.md, AGENTS.md, .env.template, openspec/config.yaml: terminology and URLs
- volumes: openclaw-data → zeroclaw-data
- GitHub refs: openclaw/openclaw → zeroclaw-labs/zeroclaw
