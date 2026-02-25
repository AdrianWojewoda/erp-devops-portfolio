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

### 2. Check alertmanager health

From inside Docker network:

```bash
docker run --rm --network app_default curlimages/curl:8.5.0 \
  -sS http://alertmanager:9093/-/healthy
```

Expected:

 - OK

 ---

 ### 3. CTrigger ERPDown alert (test)

 Stop backend:

 ```bash
docker compose stop backend
```

Wait 1–2 minutes.

Check Prometheus alerts UI:

>http://<VPS_IP>:9090/alerts (internal access only)

Restart backend:

 ```bash
docker compose start backend
```

---

### Current Alerts

- ERPDown – backend not responding
- igh5xxRate – HTTP 5xx responses detected via Traefik

---

### Security Model

- Alertmanager is not exposed publicly
- No external receivers configured yet
- Future integration: Slack / email / webhook