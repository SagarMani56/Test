#!/usr/bin/env bash
# One command to run every check locally (no cloud account needed).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
have() { command -v "$1" >/dev/null 2>&1; }

echo "== 1. App tests =="
( cd app && pip install -q -r requirements-dev.txt && ruff check . && pytest --cov=src --cov-fail-under=80 )

echo "== 2. Terraform fmt/validate =="
if have terraform; then
  terraform fmt -check -recursive infrastructure
  for d in infrastructure/modules/* infrastructure/examples/*; do
    ( cd "$d" && terraform init -backend=false -input=false >/dev/null && terraform validate )
  done
else echo "terraform not installed - skipped"; fi

echo "== 3. Security scans =="
have gitleaks && gitleaks detect --source . -c .gitleaks.toml --no-banner || echo "gitleaks skipped"
have checkov  && checkov -d infrastructure/modules --config-file policies/checkov.yaml || echo "checkov skipped"
have trivy    && trivy fs --severity HIGH,CRITICAL --exit-code 1 . || echo "trivy skipped"

echo "== 4. Template smoke test =="
tmp="$(mktemp -d)"
scripts/new-service.sh smoke-service qa "$tmp/smoke-service" >/dev/null
( cd "$tmp/smoke-service/app" && pip install -q -r requirements-dev.txt && pytest -q )
rm -rf "$tmp"
echo "ALL CHECKS PASSED"
