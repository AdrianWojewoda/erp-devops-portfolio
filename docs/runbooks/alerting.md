# Runbook: Alerting (Prometheus + Alertmanager)

## Purpose

Describe how alerting is implemented and how to validate it.

## Architecture

Prometheus evaluates alert rules.
Alertmanager handles alert routing and grouping.

Flow:

Metrics → Prometheus → Alert Rules → Alertmanager → Receiver

## Services

- Prometheus: internal only
- Alertmanager: internal only
- Grafana: exposed via Traefik

## Validate Setup

### 1. Check containers

```bash
cd /srv/erp/app
docker compose ps
```

Expected:

- prometheus
- alertmanager
- traefik
- backend

---

### 2. Check Alertmanager health

From inside Docker network:

```bash
docker run --rm --network app_default curlimages/curl:8.5.0 \
  -sS http://alertmanager:9093/-/healthy
```

Expected:

- OK

---

### 3. Check Prometheus health (internal)

From inside Docker network:

```bash
docker run --rm --network app_default curlimages/curl:8.5.0 \
  -sS http://prometheus:9090/-/healthy
```

Expected:

- Prometheus Server is Healthy.

---

### 4. Validate backend scrape status (via Prometheus API)

This validates that Prometheus is successfully scraping the ERP backend metrics endpoint.Prometheus-compatible endpoint at `/metrics`.

```bash
docker run --rm --network app_default curlimages/curl:8.5.0 \
  -sS http://prometheus:9090/api/v1/targets | head
```

Expected:

- "scrapeUrl":"http://backend:8000/metrics"
- "health":"up"
- "lastError":""

---

### 5. Trigger ERPDown alert (test)

Stop backend:

```bash
cd /srv/erp/app
docker compose stop backend
```

Wait 1–2 minutes.

Check active alerts via Prometheus API (internal):

```bash
docker run --rm --network app_default curlimages/curl:8.5.0 \
  -sS http://prometheus:9090/api/v1/alerts | head
```

Restart backend:

```bash
cd /srv/erp/app
docker compose start backend
```

After ~1–2 minutes:
- Alert disappears (resolved)

---

## Current Alerts

- ERPDown – backend not responding (based on Prometheus scrape `up{job="backend"}`)
- High5xxRate – HTTP 5xx responses detected via Traefik

---

## Security Model

- Alertmanager is not exposed publicly
- No external receivers configured yet
- Future integration: Slack / email / webhook
