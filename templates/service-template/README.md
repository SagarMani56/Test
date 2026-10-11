# {{SERVICE_NAME}}

Owned by **{{TEAM}}**. Generated from the Acme golden-path template (v1).

## Quick start
```bash
cd app && pip install -r requirements-dev.txt
pytest                       # tests
uvicorn src.main:app --reload
docker build -t {{SERVICE_NAME}} app
```
## What you get for free
| Capability | Where |
|---|---|
| CI (lint, test, Gitleaks, Trivy) | `.github/workflows/ci.yml` -> platform reusable workflow |
| Infra (VPC, DynamoDB, S3, optional ECS) | `infra/main.tf` -> `app-platform` module |
| AI spec for your agent | `docs/ai-spec.md` |
| Ownership & PR rules | `CODEOWNERS`, PR template |
