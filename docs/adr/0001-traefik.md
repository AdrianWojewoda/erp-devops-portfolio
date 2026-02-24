# ADR 0001: Traefik as Reverse Proxy

## Status
Accepted

## Context

We need a reverse proxy to:
- route traffic by hostnames/subdomains (e.g., `erp.adiwoj.pl`, `grafana.adiwoj.pl`)
- terminate TLS
- work well with Docker Compose and future CI/CD automation

## Decision

Use **Traefik** as the reverse proxy and routing layer.

## Rationale

- Native Docker provider: discovers services via labels.
- Clean subdomain routing via `Host()` rules.
- Built-in ACME support for Let's Encrypt (automated TLS).
- Good fit for incremental growth: adding a service is a label change, not manual Nginx config.

## Consequences

- Routing and exposure rules live in compose labels (must keep them consistent).
- Admin features (dashboard) must be secured / not exposed publicly.
- For complex edge features (WAF, advanced rate limits), we may later add dedicated tooling, but Traefik is sufficient for this portfolio project baseline.