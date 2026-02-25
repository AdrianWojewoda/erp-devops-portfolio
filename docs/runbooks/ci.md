# Runbook: CI Pipeline

## Purpose

Describe what is validated automatically on every push / PR.

## Where it runs

GitHub Actions → repository → Actions tab.

## What it checks

- Docker Compose config validation:
  - `docker compose -f infra/compose/prod/compose.yml config`
- Backend image build:
  - `docker build ./app/backend`
- YAML lint (`yamllint`)
- Shell lint (`shellcheck`)
- Vulnerability scanning (`trivy`) for CRITICAL/HIGH

## How to interpret failures

- Compose validation failed:
  - YAML syntax / invalid compose schema
- Backend build failed:
  - Dockerfile or dependencies issue
- Trivy failed:
  - new HIGH/CRITICAL vulnerability introduced

## Notes

CI does not deploy. Deployment remains:
Local → GitHub → VPS (manual run of `deploy.sh` on VPS).