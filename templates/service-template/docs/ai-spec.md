# AI Engineering Spec - {{SERVICE_NAME}}
Inherits: platform `docs/ai-specifications/*` (platform-spec, workflow-spec, governance-spec).

## Service-specific
- Purpose: <describe>
- API: <endpoints>
- Data: DynamoDB table from `app-platform` module (`TABLE_NAME` env var)

## Rules for the AI agent
- Do NOT add new CI workflows; extend `ci.yml` inputs only.
- Do NOT write raw AWS resources in `infra/`; use platform modules.
- Every endpoint requires a test. Coverage >= 80%.
