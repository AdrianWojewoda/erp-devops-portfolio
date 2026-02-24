#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/srv/erp/repo"
RUNTIME_DIR="/srv/erp/app"

echo "==> Updating repository..."
cd "$REPO_DIR"
git fetch --all --prune
git pull --ff-only

echo "==> Validating compose config..."
cd "$RUNTIME_DIR"
docker compose config >/dev/null

echo "==> Deploying (compose up)..."
docker compose up -d --build

echo "==> Running containers:"
docker ps

echo "==> Done."

echo "==> Smoke tests (wait up to 60s):"

retry() {
  local name="$1"
  local cmd="$2"
  local attempts=30
  local delay=2

  for i in $(seq 1 "$attempts"); do
    if eval "$cmd" >/dev/null 2>&1; then
      echo "$name: OK"
      return 0
    fi
    sleep "$delay"
  done

  echo "$name: FAILED (timeout)"
  return 1
}

# Prefer local Traefik routing to avoid DNS/TLS flakiness:
retry "ERP health"    'curl -fsS -H "Host: erp.adiwoj.pl" http://127.0.0.1/health'
retry "ERP readiness" 'curl -fsS -H "Host: erp.adiwoj.pl" http://127.0.0.1/readiness'