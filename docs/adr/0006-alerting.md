# ADR 0006 – Alerting Strategy

## Status
Accepted

## Context

The infrastructure includes reverse proxy routing and monitoring via Prometheus.
Operational visibility requires active alerting, not only dashboards.

## Decision

Introduce:

- Prometheus alert rules
- Alertmanager for routing
- Baseline alerts:
  - Service availability (ERPDown)
  - HTTP error rate (High5xxRate)

The ERP backend must expose Prometheus-compatible metrics (HTTP endpoint `/metrics`) so Prometheus can scrape it.
`ERPDown` is evaluated based on the Prometheus scrape status (`up{job="backend"}`).

Alertmanager runs internally and does not expose public endpoints.

## Rationale

- Rule-based alerting keeps monitoring deterministic
- Alertmanager decouples alert generation from delivery
- Minimal baseline ensures service availability visibility

## Consequences

- Additional service in compose stack
- Backend must provide a metrics endpoint for Prometheus scraping
- Future extension possible (Slack, email, webhooks)
- No external notification integration yet (intentional scope limit)
