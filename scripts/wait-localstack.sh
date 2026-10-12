#!/usr/bin/env bash
# Wait until LocalStack's DynamoDB and S3 are really running, then warm them up so the
# first Terraform call is not slow (slow first calls cause provider retries / timeouts).
# Usage: bash scripts/wait-localstack.sh [endpoint] [timeout-seconds]
set -euo pipefail

ENDPOINT="${1:-http://localhost:4566}"
TIMEOUT="${2:-180}"
DEADLINE=$((SECONDS + TIMEOUT))

echo "Waiting for LocalStack at ${ENDPOINT} (max ${TIMEOUT}s)..."
until health="$(curl -sf "${ENDPOINT}/_localstack/health" 2>/dev/null)" \
  && grep -Eq '"dynamodb": ?"(running|available)"' <<<"$health" \
  && grep -Eq '"s3": ?"(running|available)"' <<<"$health"; do
  if ((SECONDS >= DEADLINE)); then
    echo "ERROR: LocalStack not ready after ${TIMEOUT}s. Last health response:" >&2
    echo "${health:-<none>}" >&2
    exit 1
  fi
  sleep 3
done
echo "LocalStack services are up."

# Warm-up (best effort): needs the AWS CLI; skipped silently if it is not installed.
if command -v aws >/dev/null 2>&1; then
  export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1
  aws --endpoint-url "$ENDPOINT" dynamodb list-tables >/dev/null
  aws --endpoint-url "$ENDPOINT" s3api list-buckets >/dev/null
  echo "Warm-up calls OK."
fi
