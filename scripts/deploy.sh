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