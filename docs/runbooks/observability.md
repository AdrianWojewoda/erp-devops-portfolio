# Runbook: Observability (Prometheus + Grafana)

## Scope

This stack provides:
- Traefik metrics (Prometheus)
- Prometheus scraping (internal)
- Grafana UI (via Traefik and HTTPS)

## Access

Grafana is exposed via Traefik:

- https://grafana.adiwoj.pl

Prometheus is NOT exposed publicly by default (recommended).

## What to check first

### 1) Containers up

```bash
cd /srv/erp/app
docker ps
```

Expected: traefik, prometheus, grafana running.

### 2) Prometheus health (internal check)

Use a temporary curl container inside the same docker network:

```bash
docker run --rm --network app_default curlimages/curl:8.5.0 -sS http://prometheus:9090/-/healthy
```

Expected: Prometheus Server is Healthy.

### 3) Traefik metrics endpoint (internal)

```bash
docker run --rm --network app_default curlimages/curl:8.5.0 -sS http://traefik:8082/metrics | head
```

Expected: metrics output (e.g., go_* and traefik_* metrics).

Grafana login

Credentials are configured via environment variables in compose:

GF_SECURITY_ADMIN_USER

GF_SECURITY_ADMIN_PASSWORD

### Next improvements (planned)

Provision datasources/dashboards as code (Grafana provisioning).

Add log aggregation (Loki + Promtail).

Add alerts (Alertmanager) and SLO dashboards.