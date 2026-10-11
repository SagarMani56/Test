#!/usr/bin/env bash
# Prove the Terraform modules work with zero cloud spend.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EX="${1:-ims}"
docker compose -f "$ROOT/infrastructure/local/docker-compose.yml" up -d --wait
cd "$ROOT/infrastructure/examples/$EX"
terraform init -input=false
terraform apply -auto-approve -input=false
terraform output
echo "Verify:  aws --endpoint-url http://localhost:4566 dynamodb list-tables"
read -r -p "Press enter to destroy..." _
terraform destroy -auto-approve -input=false
docker compose -f "$ROOT/infrastructure/local/docker-compose.yml" down
