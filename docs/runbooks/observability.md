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

### Expected Metrics

- traefik_entrypoint_requests_total
- traefik_router_requests_total
- traefik_service_request_duration_seconds

### Security Model

- Prometheus not exposed externally
- Metrics endpoint not bound to public ports
- Grafana protected by credentials

### Next improvements (planned)

- Add Loki for logs
- Add Alertmanager
- Add SLO dashboards
- Add alert rules for 5xx rate