
# Runbook: Deploy / Restart

## Scope

This runbook describes how to operate the current stack on the VPS:
- Traefik (reverse proxy + TLS)
- whoami (temporary test service)
- Prometheus
- Grafana

## Preconditions

- You have SSH access as `devops` (key-based).
- Project runtime directory on VPS: `/srv/erp/app`
- Docker + docker compose plugin installed.

## Common operations

### Connect to VPS

```bash
ssh devops@<VPS_IP>
```


### Check running containers

```bash
cd /srv/erp/app
docker ps
```

### Restart the whole stack (safe default)

```bash
cd /srv/erp/app
docker compose down
docker compose up -d
```

### Apply configuration changes (compose file modified)

```bash
cd /srv/erp/app
docker compose up -d
```

### Pull newer images (manual update)

```bash
cd /srv/erp/app
docker compose pull
docker compose up -d
```

### Troubleshooting

```bash
Traefik logs
docker logs traefik --tail=200
```

### Prometheus logs

```bash
docker logs prometheus --tail=200
```

### Grafana logs

```bash
docker logs grafana --tail=200
```

### Validate compose syntax (no changes applied)

```bash
cd /srv/erp/app
docker compose config
```

### Rollback

If an update breaks the stack:

revert /srv/erp/app/docker-compose.yml to the previous version (keep copies or use your repo history),

restart the stack:

```bash
docker compose down
docker compose up -d
```

### Notes

Only Traefik should bind ports 80/443 publicly.

Keep admin interfaces unexposed unless protected and intentional.

## One-command deploy

A single script is provided for repeatable deployments on the VPS:

```bash
cd /srv/erp/repo
./scripts/deploy.sh
```

### What it does:

- git pull (fast-forward only)
- validates the runtime compose config
- docker compose up -d --build
- prints container status


---

## 3) Commit

```bash
git add scripts docs/runbooks/deploy.md
git commit -m "feat: add deployment script and document one-command deploy"
git push