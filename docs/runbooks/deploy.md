# Runbook: Deploy / Restart

## Scope

This runbook describes how to operate the current stack on the VPS:

- Traefik (reverse proxy + TLS)
- ERP Backend (FastAPI)
- PostgreSQL
- Prometheus
- Grafana

## Preconditions

- You have SSH access as `devops` (key-based).
- Runtime directory: `/srv/erp/app`
- Repository directory: `/srv/erp/repo`
- Docker + Docker Compose v2 plugin installed.

---

## Connect to VPS

```bash
ssh devops@<VPS_IP>
```

## Common operations

---

## Quick Status

```bash
cd /srv/erp/app
docker compose ps
```

---

## Validate config (no changes applied):

```bash
cd /srv/erp/app
docker compose config
```

---

## Standard Deployment (recommended)

```bash
cd /srv/erp/repo
./scripts/deploy.sh
```

### What The Script Does

1. Pulls latest changes (fast-forward only)
2. Validates compose configuration
3. Builds and recreates containers
4. Displays running containers
5. Executes smoke tests:
- GET /health
- GET /readiness

---

## Idempotency

The deployment process is idempotent.

Running `deploy.sh` multiple times will reconcile the desired state without manual cleanup.
Containers are recreated only if configuration or images changed.

---

## Restart / Recreate

Safe default (reconcile desired state):

```bash
cd /srv/erp/app
docker compose up -d --build
```

Hard restart (stops and starts containers, keeps volumes):

```bash
cd /srv/erp/app
docker compose restart
```

Full teardown (use only when required):

```bash
cd /srv/erp/app
docker compose down
docker compose up -d --build
```

---

## Manual Deployment

If needed:

```bash
cd /srv/erp/app
docker compose pull
docker compose up -d
```

## Logs

Traefik:

```bash
cd /srv/erp/app
docker logs app-traefik-1 --tail=200
```

Backend:

```bash
cd /srv/erp/app
docker logs app-backend-1 --tail=200
```

Database:

```bash
cd /srv/erp/app
docker compose logs db --tail=200
```

Prometheus:

```bash
cd /srv/erp/app
docker compose logs prometheus --tail=200
```

Grafana:

```bash
cd /srv/erp/app
docker compose logs grafana --tail=200
```
---

## Smoke Tests

From VPS (via Traefik locally):

```bash
curl -fsS -H "Host: erp.adiwoj.pl" http://127.0.0.1/health
curl -fsS -H "Host: erp.adiwoj.pl" http://127.0.0.1/readiness
```

From your local machine:

```bash
curl -fsS https://erp.adiwoj.pl/health
curl -fsS https://erp.adiwoj.pl/readiness
```

---

## Rollback

### Option A: rollback to a previous commit

```bash
cd /srv/erp/repo
git reset --hard <commit_sha>
bash ./scripts/deploy.sh
```

### Option B: rollback to previous images (if applicable)

```bash
cd /srv/erp/app
docker compose up -d
```

## Notes / Guardrails

- Only Traefik should bind ports 80/443 publicly.
- Never expose Postgres or Prometheus externally.
- ACME storage (acme.json) must never be committed.
- Runtime secrets should live in /srv/erp/app/.env (not in git).
- Compose project name is pinned: COMPOSE_PROJECT_NAME=erp to avoid duplicate stacks.

## **Known issues**

- “Smoke tests may fail immediately after recreation; deploy script retries for up to 60s”
- “If VPS repo diverges after force push: `git fetch --all && git reset --hard origin/main`”
