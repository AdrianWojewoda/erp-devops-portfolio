#!/usr/bin/env bash
set -euo pipefail
set -o errtrace

trap 'echo "Deploy failed at line $LINENO"; exit 1' ERR

REPO_DIR="/srv/erp/repo"
RUNTIME_DIR="/srv/erp/app"

# Always deploy under a single compose project name
export COMPOSE_PROJECT_NAME="erp"

# Compose file path (single source of truth)
COMPOSE_FILE="$RUNTIME_DIR/infra/compose/prod/compose.yml"
if [[ ! -f "$COMPOSE_FILE" ]]; then
  echo "Missing compose file: $COMPOSE_FILE"
  exit 1
fi

echo "==> Updating repository..."
cd "$REPO_DIR"
git fetch --all --prune
git pull --ff-only

echo "==> Syncing runtime directory..."
rsync -a --delete --no-owner --no-group \
  --exclude '.git/' \
  --exclude '.github/' \
  --exclude '.env' \
  "$REPO_DIR"/ "$RUNTIME_DIR"/

echo "==> Loading runtime env (.env)..."
if [[ -f "$RUNTIME_DIR/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$RUNTIME_DIR/.env"
  set +a
fi

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

# Optional: fail early if Grafana password is missing (recommended)
: "${GRAFANA_ADMIN_PASSWORD:?GRAFANA_ADMIN_PASSWORD is not set (define it in $RUNTIME_DIR/.env)}"

# Guard: prevent the "rules/*.yml is a directory" bug
if [[ -d "$RUNTIME_DIR/infra/compose/prod/monitoring/rules/*.yml" ]]; then
  echo "Invalid runtime state: rules/*.yml is a directory (should not exist)."
  exit 1
fi

echo "==> Validating compose config..."
cd "$RUNTIME_DIR"
docker compose -f "$COMPOSE_FILE" config >/dev/null

# Optional cleanup: if someone accidentally started a different project earlier
# This prevents "two stacks" (prod_*) from lingering and grabbing ports.
if docker ps --format '{{.Names}}' | grep -q '^prod-'; then
  echo "==> Cleaning up accidental 'prod' project..."
  docker compose -p prod down || true
fi

echo "==> Deploying (compose up)..."
docker compose -f "$COMPOSE_FILE" up -d --build

echo "==> Running containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

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

echo "==> Done."