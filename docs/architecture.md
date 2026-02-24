# Architecture

## Goals

- Provide a production-like baseline on a single Ubuntu VPS.
- Use containerization and reverse proxy routing by subdomains.
- Automate TLS with Let's Encrypt (ACME).
- Build a foundation for an ERP web app (later) with DevOps practices: security, repeatability, observability.

## System context (C4 - Level 1)

```mermaid
flowchart LR
  U[User / Browser] -->|HTTPS| RP[Reverse Proxy: Traefik]
  RP --> S1[Service: ERP (future)]
  RP --> S2[Service: Grafana (observability)]
  S1 --> DB[(PostgreSQL - future)]
  RP --> M[Metrics endpoint]
  M --> P[Prometheus]
  P --> G[Grafana]

```

## Containers (C4 - Level 2)

### Public entrypoints

Traefik: terminates TLS, routes requests by Host() rules.

entrypoint web :80 (HTTP)

entrypoint websecure :443 (HTTPS)

(internal) entrypoint metrics :8082 (Prometheus scrape)

### Services

whoami (temporary): test service to validate routing + TLS + redirects.

prometheus: scrapes Traefik metrics from internal network.

grafana: visualization (exposed via Traefik under grafana.adiwoj.pl).

### Networking model

Only ports exposed to the public internet: 80/443 (plus SSH 22).

Application/monitoring services are not exposed directly; they are reached via Traefik routing.

Internal scraping (Prometheus -> Traefik metrics) happens within the Docker network.

### DNS / Hostnames

erp.adiwoj.pl → routes to ERP entrypoint (currently whoami test service).

grafana.adiwoj.pl → routes to Grafana UI via Traefik.

Both subdomains have A records pointing to the VPS public IP.

### Data & persistence

Traefik ACME state stored in /srv/erp/app/acme.json (bind-mounted into Traefik).

Future: PostgreSQL data in /srv/erp/data/postgres and backups in /srv/erp/backups.

### Security baseline (current)

SSH: root login disabled, password login disabled, key-based auth only.

Firewall: UFW allows only 22/80/443 (plus temporary 8080 during early debugging).

Fail2ban enabled for SSH.

TLS handled by Let's Encrypt, auto-renewed by Traefik.

### Future extensions

Add application stack: FastAPI + PostgreSQL + migrations.

Add centralized logs (Loki) and dashboards provisioned “as code”.

Add provisioning via Ansible and CI/CD deploy from GitHub Actions.