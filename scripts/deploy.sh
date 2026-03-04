#!/usr/bin/env bash
set -euo pipefail
set -o errtrace

trap 'echo "Deploy failed at line $LINENO"; exit 1' ERR

REPO_DIR="/srv/erp/repo"
RUNTIME_DIR="/srv/erp/app"

echo "==> Updating repository..."
cd "$REPO_DIR"
git fetch --all --prune
git pull --ff-only

echo "==> Syncing runtime directory..."
rsync -a --delete --no-owner --no-group \
  --exclude '.git/' \
  --exclude '.github/' \
  "$REPO_DIR"/ "$RUNTIME_DIR"/

echo "==> Validating required files exist in runtime..."
for f in \
  "$RUNTIME_DIR/infra/compose/prod/monitoring/prometheus.yml" \
  "$RUNTIME_DIR/infra/compose/prod/monitoring/rules/alerts.yml" \
  "$RUNTIME_DIR/infra/compose/prod/monitoring/alertmanager.yml"
do
  if [[ ! -f "$f" ]]; then
    echo "Missing file: $f"
    exit 1
  fi
done

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
  shift

  local attempts=30
  local delay=2

  for i in $(seq 1 "$attempts"); do
    if "$@" >/dev/null 2>&1; then
      echo "$name: OK"
      return 0
    fi
    echo "$name: retry $i/$attempts..."
    sleep "$delay"
  done

  echo "$name: FAILED (timeout)"
  return 1
}

retry "ERP health" curl -fsS -H "Host: erp.adiwoj.pl" http://127.0.0.1/health
retry "ERP readiness" curl -fsS -H "Host: erp.adiwoj.pl" http://127.0.0.1/readiness