# Quick Deploy Runbook

## 1. Install Docker + Compose (Ubuntu/Debian)

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

docker --version
docker compose version
```

## 2. Prepare DNS And Firewall

- Point A records to server IP:
- `claw.devserver.sh` (or your `PROXY_DOMAIN`)
- `baserow.devserver.sh` (or your `BASEROW_DOMAIN`)
- Open inbound ports: `80/tcp`, `443/tcp`

## 3. Clone Project

```bash
git clone <your-repo-url> /opt/moltis-n8n-ai
cd /opt/moltis-n8n-ai
```

## 4. Configure Environment

```bash
cp .env.template .env
```

Fill required values in `.env`:

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

Generate secrets:

```bash
openssl rand -hex 32
```

## 5. GHCR Login (Only If Image Is Private)

```bash
docker login ghcr.io
```

## 6. Start Stack

```bash
cd /opt/moltis-n8n-ai
docker compose config
./scripts/create-external-volumes.sh
docker compose up -d
```

## 7. Verify

```bash
docker compose ps
docker compose logs --tail=100 traefik moltis litellm n8n baserow-backend
```

Open:

- `https://${PROXY_DOMAIN}/`
- `https://${PROXY_DOMAIN}/llm`
- `https://${PROXY_DOMAIN}/n8n/`
- `https://${BASEROW_DOMAIN}/`
- `https://${PROXY_DOMAIN}/dozzle/`
- `https://${PROXY_DOMAIN}/traefik/`

## 8. Update

```bash
cd /opt/moltis-n8n-ai
git pull
docker compose pull
docker compose up -d
```

## 9. Common Commands

```bash
docker compose logs -f
docker compose logs -f moltis litellm n8n
docker compose logs -f baserow-backend baserow-web-frontend
docker compose restart
docker compose down
```
