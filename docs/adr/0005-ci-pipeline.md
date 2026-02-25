# ADR 0005: CI Validation and Security Scanning

## Status
Accepted

## Context

Changes to infrastructure should be validated automatically to reduce deployment risk.
Security scanning should catch high-severity vulnerabilities early.

## Decision

Introduce GitHub Actions CI with:
- docker compose validation
- backend image build
- yaml lint
- shellcheck
- trivy scan (HIGH/CRITICAL)

CI will not deploy automatically.

## Rationale

- Improves reliability and review quality
- Keeps deployment model simple (SSH-based)
- Avoids premature CD complexity while still enforcing standards

## Consequences

Positive:
- Faster feedback loop
- Reduced runtime failures
- Basic security gate

Trade-offs:
- CI runtime cost (minutes)
- Occasional false positives in scanning