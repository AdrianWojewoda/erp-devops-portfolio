# ERP DevOps Portfolio

Production-like infrastructure for a web-based ERP system running on a single Ubuntu VPS.

This repository documents the incremental evolution of a secure, observable and TLS-enabled environment designed using modern DevOps practices.

---

## 🔎 Project Status

Current milestone: **v0.3 – Reverse Proxy + TLS + Observability Baseline**

- VPS hardening
- Dockerized infrastructure
- Traefik reverse proxy
- Automated HTTPS (Let's Encrypt)
- Prometheus metrics
- Grafana visualization
- Infrastructure documentation (C4, ADR, Runbooks)

---

## Live Endpoints

- ERP (test service): https://erp.adiwoj.pl
- Observability: https://grafana.adiwoj.pl

---

## What This Project Demonstrates

This project focuses on infrastructure maturity rather than application complexity.

Key DevOps capabilities demonstrated

- Reverse proxy routing by subdomain
- Automated TLS with ACME (no manual cert handling)
- Docker-based service isolation
- Internal vs public networking separation
- Firewall + SSH hardening
- Observability stack integration
- Infrastructure documentation (C4, ADRs, runbooks)
- Incremental, versioned evolution

---

## Architecture Overview

### High-Level Flow

```mermaid
flowchart LR
  User -->|HTTPS| Traefik
  Traefik --> ERP
  Traefik --> Grafana
  Traefik --> Metrics
  Metrics --> Prometheus
  Prometheus --> Grafana
```

## Network Model

- Public ports: 22 (SSH), 80 (HTTP), 443 (HTTPS)ns
- Only Traefik binds to 80/443
- Prometheus and metrics entrypoints are internal-only
- TLS termination at edge (Traefik)

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

## Deployment Model

Current model:
- Single VPS
- SSH-based deployment
- Docker Compose

Planned evolution:
- GitHub Actions CI validation
- Image scanning (Trivy)
- Infrastructure provisioning via Ansible
- Log aggregation (Loki)
- Alerts (Alertmanager)
- Application layer (FastAPI + PostgreSQL)

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

- Root SSH login disabled
- Password authentication disabled
- Key-based SSH only
- UFW restricting public exposure
- Fail2ban enabled
- ACME key material excluded from repository
- Metrics endpoints not publicly exposed

---

## Versioning Strategy

Milestones:
- v0.1 – VPS hardening + Docker baseline
- v0.2 – Traefik + Automated TLSd
- v0.3 – Observability stack
- v0.4 – Application layer (planned)
- v1.0 – Production-ready ERP stack

---

## Roadmap

- [ ] FastAPI ERP backend
- [ ] PostgreSQL with migrations
- [ ] Healthchecks & readiness probes
- [ ] CI pipeline validation
- [ ] Container image scanning
- [ ] Loki (centralized logs)
- [ ] Alertmanager
- [ ] Infrastructure provisioning via Ansible

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

## 📌 Why This Project Exists

This repository demonstrates the incremental evolution of a production-ready stack, starting from a clean VPS to a secured, observable environment ready for application deployment.