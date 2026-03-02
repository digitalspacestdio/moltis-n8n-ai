## 1. Docker Compose

- [x] 1.1 Replace openclaw service with zeroclaw: image ghcr.io/zeroclaw-labs/zeroclaw, service name zeroclaw, container_name zeroclaw-gateway
- [x] 1.2 Update volumes: zeroclaw-data for persistence, mount workspace and config/zeroclaw.toml
- [x] 1.3 Set env: API_KEY, ZEROCLAW_ALLOW_PUBLIC_BIND=true, ZEROCLAW_GATEWAY_PORT=3456
- [x] 1.4 Rename volume openclaw-data → zeroclaw-data
- [x] 1.5 Update n8n comment "shared with zeroclaw" (not OpenClaw)

## 2. Config

- [x] 2.1 Create config/zeroclaw.example.toml with gateway port 3456, n8n webhook base, api_key placeholder
- [x] 2.2 Remove config/openclaw.example.json or add deprecation note

## 3. Documentation

- [x] 3.1 Update README.md: title, links, architecture diagram, config section, backup commands
- [x] 3.2 Update AGENTS.md: config path openclaw.json → zeroclaw.toml, docker logs service name
- [x] 3.3 Update .env.template: header "zeroclaw + n8n Stack"
- [x] 3.4 Update openspec/config.yaml: Node.js → Rust in context
