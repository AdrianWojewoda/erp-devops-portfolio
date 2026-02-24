# ADR 0002: Let's Encrypt for TLS Certificates

## Status
Accepted

## Context

A commercial certificate (home.pl) was available but bound to a specific hostname.
This project aims to demonstrate modern DevOps practices:
- automation
- repeatability
- low operational overhead

We also plan multiple subdomains over time (`erp`, `grafana`, potentially `api`, `staging`, etc.).

## Decision

Use **Let's Encrypt** certificates managed automatically by Traefik using ACME HTTP-01 challenge.

## Rationale

- Fully automated issuance and renewal.
- Eliminates manual certificate handling and rotation tasks.
- Scales well with multiple subdomains without extra operational burden.
- Reflects common modern production practice for public services.

## Consequences

- Port 80 must remain reachable for HTTP-01 challenges.
- DNS must correctly point to the VPS.
- `acme.json` must be protected (contains sensitive key material) and never committed to Git.

## Notes

The commercial certificate can still be used later if:
- a corporate CA is required, or
- a specific OV/EV policy is needed.
For this portfolio project, automation is prioritized.