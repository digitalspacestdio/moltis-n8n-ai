# moltis + n8n Stack

Self-hosted automation stack with `moltis`, `litellm`, `n8n`, `traefik`, `postgres`, `baserow`, and `dozzle`.

## Services

- `moltis` - AI gateway/UI on `https://${PROXY_DOMAIN}/`
- `litellm` - OpenAI-compatible proxy on `https://${PROXY_DOMAIN}/llm`
- `n8n` - workflows on `https://${PROXY_DOMAIN}/n8n/`
- `baserow` - no-code DB UI on `https://${BASEROW_DOMAIN}/`
- `dozzle` - logs UI on `https://${PROXY_DOMAIN}/dozzle/`
- `traefik` - reverse proxy and Let's Encrypt TLS
- `postgres` - shared database

## Deployment On Clean Server

### 1. Prerequisites

- Linux server with public IP (Ubuntu 22.04/24.04 or Debian 12 recommended)
- Root access or user with `sudo`
- DNS records already pointed to server:
- `${PROXY_DOMAIN}` (example: `claw.devserver.sh`)
- `${BASEROW_DOMAIN}` (example: `baserow.devserver.sh`)
- Open inbound ports `80/tcp` and `443/tcp`
- Outbound internet access from server (Docker Hub + GHCR + ACME)

### 2. Install Docker + Compose

Ubuntu/Debian:

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
  $(. /etc/os-release; echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
```

Check:

```bash
docker --version
docker compose version
```

### 3. Clone Project

```bash
git clone <your-repo-url> /opt/moltis-n8n-ai
cd /opt/moltis-n8n-ai
```

### 4. Create `.env`

```bash
cp .env.template .env
```

Set required values in `.env`:

- `LITELLM_API_KEY`
- `MOLTIS_PASSWORD`
- `PROXY_DOMAIN`
- `BASEROW_DOMAIN`
- `PROXY_EMAIL`
- `DB_USER`
- `DB_PASSWORD`
- `DB_NAME`
- `LITELLM_DB`
- `BASEROW_DB`
- `BASEROW_SECRET_KEY`
- `BASEROW_JWT_SIGNING_KEY`
- `BASEROW_REDIS_PASSWORD`

Generate strong secrets:

```bash
openssl rand -hex 32
```

### 5. (Optional) Login To GHCR

Required only if `ghcr.io/digitalspacestdio/moltis-n8n-ai-moltis:latest` is private:

```bash
docker login ghcr.io
```

### 6. Start Stack

```bash
docker compose config
./scripts/create-external-volumes.sh
docker compose up -d
```

### 7. Verify

```bash
docker compose ps
docker compose logs --tail=100 traefik moltis litellm n8n baserow-backend
```

Open in browser:

- `https://${PROXY_DOMAIN}/`
- `https://${PROXY_DOMAIN}/llm`
- `https://${PROXY_DOMAIN}/n8n/`
- `https://${BASEROW_DOMAIN}/`
- `https://${PROXY_DOMAIN}/dozzle/`
- `https://${PROXY_DOMAIN}/traefik/`

If HTTPS certificate is not issued immediately, wait 1-2 minutes and check Traefik logs.

## Update Procedure

```bash
cd /opt/moltis-n8n-ai
git pull
docker compose pull
docker compose up -d
```

## Useful Commands

```bash
docker compose config
docker compose ps
docker compose logs -f moltis litellm n8n
docker compose logs -f baserow-backend baserow-web-frontend
docker compose down
```

## Notes

- `moltis` image: `ghcr.io/digitalspacestdio/moltis-n8n-ai-moltis:latest`
- `moltis` runs with `--no-tls`; TLS is terminated by Traefik.
- Main moltis config is mounted from `config/moltis.toml`.
- Named volumes are configured as `external` to prevent accidental removal via `docker compose down -v`.
- Create missing volumes before first start: `./scripts/create-external-volumes.sh`.
- Internal webhook URL from containers to n8n:
- `http://n8n:5678/webhook/<path>`

## License

MIT
