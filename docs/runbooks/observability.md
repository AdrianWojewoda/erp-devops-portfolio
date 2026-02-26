# Runbook: Observability (Prometheus + Grafana)

## Scope

This stack provides infrastructure-level observability:

- Traefik metrics exporter
- Application metrics from ERP backend (Prometheus format)
- Prometheus scraping and storage
- Grafana dashboards exposed via HTTPS

Metrics flow:

Traefik + Backend → Prometheus → Grafana

---

## Access

Grafana (public via Traefik):

https://grafana.adiwoj.pl

Prometheus:
- Internal-only
- Not exposed to public network
- Accessible only inside Docker network

---

## Architecture Components

### Traefik

- Exposes Prometheus metrics on internal entrypoint `:8082`
- Metrics enabled via `--metrics.prometheus=true`

### Backend (ERP)

- Exposes a Prometheus-compatible metrics endpoint at `/metrics`
- Scraped by Prometheus via internal Docker network

### Prometheus

- Scrapes Traefik metrics and backend metrics
- Config defined in:
  infra/compose/prod/monitoring/prometheus.yml
- Runs on internal Docker network

### Grafana

- Connected to Prometheus via internal service name
- Provisioned using configuration as code
- Exposed externally through Traefik

---

## Operational Checks

### 1. Containers running

```bash
cd /srv/erp/app
docker compose ps
```

Expected:

- traefik
- prometheus
- grafana

---

### 2. Prometheus health (internal)

```bash
docker run --rm --network app_default \
  curlimages/curl:8.5.0 \
  -sS http://prometheus:9090/-/healthy
```

Expected:

- Prometheus Server is Healthy.

---

### 3. Traefik metrics endpoint

```bash
docker run --rm --network app_default \
  curlimages/curl:8.5.0 \
  -sS http://traefik:8082/metrics | head
```

Expected:

- traefik_entrypoint_requests_total
- traefik_router_requests_total
- traefik_service_request_duration_seconds

---

### 4. Backend scrape verification (Prometheus view)

Rather than testing DNS resolution inside individual containers, backend metrics health is verified via Prometheus target status.

```bash
docker run --rm --network app_default \
  curlimages/curl:8.5.0 \
  -sS http://prometheus:9090/api/v1/targets | head
```

Expected:

- "job":"backend
- "health":"up"

Backend metrics endpoint remains available at:

> http://backend:8000/metrics

---

## Troubleshooting

### Case 1: Grafana loads but shows "No data"

Check:

```bash
docker compose logs prometheus --tail=100
```

Verify:

- Prometheus is scraping successfully
- No target errors

### Case 2: Prometheus shows no targets

Check scrape configuration:

```bash
cat infra/compose/prod/monitoring/prometheus.yml
```

Ensure:

- Targets are correctly defined
- Service names match Docker network

### Case 3: Traefik metrics not available

Check Traefik logs:

```bash
docker compose logs traefik --tail=100
```

Verify:

- metrics.prometheus=true enabled
- Metrics entrypoint defined

---

## Data Persistence

- Prometheus data stored in container filesystem (ephemeral unless volume configured)
- Grafana provisioning stored in bind-mounted directory
- Dashboards can be version-controlled

---

## Security Model

- Prometheus not publicly exposed
- Metrics endpoints internal-only
- Grafana protected by credentials
- TLS terminated at Traefik

---

## Planned Improvements

- Loki for centralized logs
- Alert receiver integration (Slack / email / webhook)
- SLO-based dashboards
- Error-rate alert rules (5xx thresholds)
