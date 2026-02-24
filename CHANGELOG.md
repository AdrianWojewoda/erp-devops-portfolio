# Changelog
All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project loosely follows Semantic Versioning.

## [Unreleased]
### Added
- CI workflow for validation (planned)
### Changed
- -
### Fixed
- -

## [0.4.0] - 2026-02-23
### Added
- FastAPI backend container with /health and /readiness
- PostgreSQL service with persistent volume
- Deployment script with smoke tests and retry logic
- HTTP→HTTPS redirects for ERP and Grafana routes
- Grafana + Prometheus monitoring stack exposed via Traefik

### Changed
- Compose structure refactored for production-like runtime
- Traefik config updated to include Prometheus metrics entrypoint

### Fixed
- Compose validation issues (volumes placement, build context paths)
- Traefik Docker provider API mismatch (early setup issue)

## [0.3.0] - 2026-02-23
### Added
- Traefik reverse proxy baseline
- Let's Encrypt ACME automation
- Prometheus + Grafana baseline
- Initial runbooks and ADRs