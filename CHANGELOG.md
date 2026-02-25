# Changelog
All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project loosely follows Semantic Versioning.

## [Unreleased]
### Added
- -
### Changed
- -
### Fixed
- -
---

## [0.6.0] - 2026-02-25

### Added
- Alertmanager service
- Prometheus alert rules (ERPDown, High5xxRate)
- Backend scrape configuration
- Alerting pipeline integrated with monitoring stack
- .trivyignore for managed exceptions.
- Trivy report uploaded as artifact
- Security remediation workflow for dependency upgrades

### Changed
- CI now enforces Trivy as a security gate (fails on HIGH/CRITICAL vulnerabilities).

### Fixed
- Upgraded FastAPI/Starlette dependency chain to remediate CVE-2024-47874

---

## [0.5.0] - 2026-02-25

### Added
- GitHub Actions CI pipeline
- Docker Compose validation in CI
- YAML linting (yamllint)
- Shell script linting (ShellCheck)
- Container image vulnerability scanning (Trivy)
- ADR 0005: CI validation and security scanning
- CI runbook documentation

### Changed
- Repository structure formalized
- Deployment documentation refined
- README updated to reflect CI maturity

### Fixed
- YAML formatting inconsistencies
- ShellCheck warnings in deployment script

---

## [0.4.0] - 2026-02-24
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