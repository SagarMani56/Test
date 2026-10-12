#!/usr/bin/env bash
# Wait until LocalStack's DynamoDB, S3 and KMS are usable, then warm them up so the first
# Terraform call is not slow (slow first calls cause provider retries / timeouts).
# Usage: bash scripts/wait-localstack.sh [endpoint] [timeout-seconds]
set -euo pipefail

ENDPOINT="${1:-http://localhost:4566}"
TIMEOUT="${2:-180}"
DEADLINE=$((SECONDS + TIMEOUT))
health=""

# A service counts as ready when LocalStack reports it as running or available
# (available = loaded lazily on first use, which the warm-up below triggers).
ready() { grep -Eq "\"$1\": ?\"(running|available)\"" <<<"$health"; }

echo "Waiting for LocalStack at ${ENDPOINT} (max ${TIMEOUT}s)..."
while true; do
  health="$(curl -sf "${ENDPOINT}/_localstack/health" 2>/dev/null || true)"
  if [[ -n "$health" ]] && ready dynamodb && ready s3 && ready kms; then
    break
  fi
  if ((SECONDS >= DEADLINE)); then
    echo "ERROR: LocalStack not ready after ${TIMEOUT}s. Last health response:" >&2
    echo "${health:-<no response>}" >&2
    exit 1
  fi
  sleep 3
done
echo "LocalStack reports DynamoDB and S3 ready: ${health}"

# Warm-up: forces lazily-loaded services to start. Needs the AWS CLI (present on GitHub runners).
if command -v aws >/dev/null 2>&1; then
  export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1
  for attempt in 1 2 3 4 5 6; do
    if aws --endpoint-url "$ENDPOINT" dynamodb list-tables >/dev/null 2>&1 \
      && aws --endpoint-url "$ENDPOINT" s3api list-buckets >/dev/null 2>&1; then
      echo "Warm-up calls OK."
      exit 0
    fi
    echo "Warm-up attempt ${attempt} not ready yet, retrying..."
    sleep 5
  done
  echo "ERROR: warm-up calls kept failing" >&2
  exit 1
else
  echo "aws CLI not found - skipping warm-up."
fi
