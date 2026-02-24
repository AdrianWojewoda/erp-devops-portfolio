# ADR 0003: Observability Stack (Prometheus + Grafana)

## Status
Accepted

## Context

The project requires visibility into:
- request volume
- error rates
- latency
- service health

As this is a DevOps portfolio project, observability is a key demonstration area.

## Decision

Use:
- Prometheus for metrics collection
- Grafana for visualization
- Traefik as metrics exporter

## Rationale

- Prometheus is industry standard
- Native Traefik Prometheus integration
- Easy extension to future services
- Clear separation between public and internal services

## Alternatives Considered

- Cloud-based monitoring (not suitable for self-hosted VPS demo)
- Direct Grafana scraping without Prometheus (less scalable)

## Consequences

Positive:
- Clear insight into reverse proxy traffic
- Scalable for future services

Negative:
- Additional operational complexity
- Requires documentation and maintenance

## Future Direction

- Add Loki for logs
- Add Alertmanager for alerting
- Define SLO-based dashboards