#!/usr/bin/env bash
# Self-service onboarding: scaffold a new service from the golden-path template.
# Usage: scripts/new-service.sh <service-name> <team> [target-dir]
set -euo pipefail

SERVICE="${1:?usage: new-service.sh <service-name> <team> [target-dir]}"
TEAM="${2:?team required}"
TARGET="${3:-./${SERVICE}}"
PLATFORM_REPO="${PLATFORM_REPO:-SagarMani56/Test}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! [[ "$SERVICE" =~ ^[a-z][a-z0-9-]{2,30}$ ]]; then
  echo "ERROR: service name must be 3-31 chars: lowercase, digits, hyphens" >&2
  exit 1
fi
if [[ -e "$TARGET" ]]; then
  echo "ERROR: $TARGET already exists" >&2
  exit 1
fi

cp -R "$ROOT/templates/service-template" "$TARGET"

# Replace placeholders in every text file (portable: no sed -i differences)
while IFS= read -r -d '' f; do
  tmp="$(mktemp)"
  sed -e "s|{{SERVICE_NAME}}|${SERVICE}|g" \
      -e "s|{{TEAM}}|${TEAM}|g" \
      -e "s|{{PLATFORM_REPO}}|${PLATFORM_REPO}|g" "$f" > "$tmp"
  cat "$tmp" > "$f"; rm -f "$tmp"
done < <(find "$TARGET" -type f -not -name '*.pyc' -print0)

( cd "$TARGET" && git init -q && git add -A && git commit -qm "chore: scaffold ${SERVICE} from golden-path template" \
    --author="platform <platform@acme.local>" 2>/dev/null || true )

echo "Created $TARGET"
echo "Next: cd $TARGET/app && pip install -r requirements-dev.txt && pytest"
