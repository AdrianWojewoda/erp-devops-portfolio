# ERP DevOps Portfolio

Production-like infrastructure for a web-based ERP system running on a single Ubuntu VPS.

## What This Project Demonstrates

This project focuses on infrastructure maturity rather than application complexity.

DevOps capabilities:

- Subdomain-based routing via reverse proxy
- Automated TLS issuance and renewal
- Public vs internal network separation
- Metrics exposure and scraping
- Infrastructure as Code (Docker Compose)
- Secure server baseline
- Deployment automation
- Architecture documentation

---

## Current Milestone

v0.4 – Reverse Proxy + TLS + Observability + Application Layer

Implemented:

- VPS hardening (SSH, UFW, Fail2ban)
- Docker-based service isolation
- Traefik reverse proxy (v3)
- Automated HTTPS via Let's Encrypt (ACME HTTP-01)
- Prometheus metrics collection
- Grafana dashboards
- FastAPI backend
- PostgreSQL database
- One-command deployment script
- C4 documentation + ADR + runbooks

---

## Live Endpoints

- ERP API: https://erp.adiwoj.pl
- Observability (Grafana): https://grafana.adiwoj.pl

---

## Architecture Overview

```mermaid
flowchart LR
  U[User] -->|HTTPS| T[Traefik]
  T --> ERP[FastAPI Backend]
  T --> G[Grafana]
  ERP --> DB[(PostgreSQL)]
  T --> M[Metrics Endpoint]
  M --> P[Prometheus]
  P --> G
```
---

## Tech Stack

|Layer |	Tool|
|------|------|
|OS	| Ubuntu 24|
|Container Runtime	| Docker CE|
|Reverse Proxy	| Traefik v3|
|TLS	| Let's Encrypt|
|Metrics	| Prometheus|
|Visualization	| Grafana|
|Firewall	| UFW|
|Intrusion Protection	| Fail2ban|

---

## Network Model

Public:
- 22 (SSH)
- 80 (HTTP)
- 443 (HTTPS)

Internal:
- 8000 (backend)
- 5432 (Postgres)
- 9090 (Prometheus)
- 8082 (Traefik metrics)

Only Traefik binds public ports.

TLS termination occurs at the edge.

---

## Operational Characteristics

- Idempotent deployment [deploy.md](docs/runbooks/deploy.md)
- Health-based validation before marking deploy successful
- HTTP → HTTPS enforced
- Metrics isolated from public network
- Runtime secrets excluded from repository
- ACME storage not committed


## Deployment

On VPS:

```bash
cd /srv/erp/repo
bash ./scripts/deploy.sh
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

## Documentation

Architecture: 
- [docs/architecture.md](docs/architecture.md)

Runbooks:
- [docs/runbooks/deploy.md](docs/runbooks/deploy.md)
- [docs/runbooks/ssl.md](docs/runbooks/ssl.md)
- [docs/runbooks/observability.md](docs/runbooks/observability.md)

Architecture Decisions:
- [docs/adr/0001-traefik.md](docs/adr/0001-traefik.md)
- [docs/adr/0002-letsencrypt.md](docs/adr/0002-letsencrypt.md)
- [docs/adr/0003-observability.md](docs/adr/0003-observability.md)

---

## Security Baseline

- Root login disabled
- Password authentication disabled
- SSH key-based access only
- UFW restricting public exposure
- Fail2ban enabled
- ACME key material excluded from repository
- Prometheus not publicly exposed

---

## Versioning Strategy

Milestones:
- v0.1 – VPS hardening + Docker baseline
- v0.2 – Traefik + Automated TLS
- v0.3 – Observability stack
- v0.4 – Application layer
- v1.0 – Production-ready ERP stack

---

## Roadmap

- [x] FastAPI ERP backend
- [x] PostgreSQL with migrations
- [x] Healthchecks & readiness probes
- [ ] CI pipeline validation
- [ ] Container image scanning (Trivy)
- [ ] Loki (centralized logs)
- [ ] Alertmanager
- [ ] Infrastructure provisioning via Ansible
- [ ] Database migrations (Alembic)

---

## Author

This project is part of my DevOps portfolio.

Focus areas:
- Infrastructure design
- Observability engineering
- Reverse proxy and TLS automation
- Observability integration
- Documentation-driven architecture

---

## Why This Project Exists

This repository documents the incremental evolution of a production-ready stack starting from a clean VPS and building toward a secure, observable, and automated infrastructure platform.