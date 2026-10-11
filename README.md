# group1-advanced — Acme Retail Internal Developer Platform

Reusable, secure, self-service engineering platform that replaces duplicated pipelines, Terraform and repo
layouts across application teams. Reference app: **Inventory Management System (IMS)**.

> Rename the GitHub repo to `<group_number>-advanced` (e.g. `group7-advanced`).

## What's inside
| Path | Purpose |
|---|---|
| `docs/ai-specifications/` | **6 AI Engineering Specs** (primary artifact) |
| `infrastructure/modules/` | 6 reusable Terraform modules (+ composite `app-platform`) |
| `infrastructure/examples/` | IMS + Team-B consuming the same module; LocalStack-ready |
| `.github/workflows/` | 3 reusable workflows + callers + platform self-test |
| `templates/service-template/` | Golden-path repo template |
| `scripts/` | `new-service.sh`, `validate-local.sh`, `localstack-demo.sh` |
| `policies/` | Checkov, Gitleaks, Trivy, yamllint config |
| `app/` | Reference IMS (FastAPI) with tests + Dockerfile |
| `docs/architecture/` | Mermaid diagrams |
| `docs/engineering-decisions/` | 6 ADRs |
| `docs/presentation/` | Final deck |

## 60-second tour
```bash
make test                                   # reference app tests
make new-service NAME=orders-service TEAM=commerce   # Team B onboarding
make validate                               # every check, locally
make localstack EX=team-b-orders            # Terraform apply with no cloud
```

## Business problem -> platform answer
| Problem | Solution |
|---|---|
| Duplicate pipelines | `reusable-*.yml`, callers <= 20 lines |
| Duplicate Terraform | `app-platform` module, ~8 lines per app |
| Different repo structures | `service-template` + scaffolder |
| Inconsistent AI specs | 6 inheriting specs + per-service `ai-spec.md` |
| Long onboarding | `make new-service` -> green CI in minutes |
| High maintenance | Fix once, bump `@v1`; Dependabot |

Full tutorial: [docs/HOWTO.md](docs/HOWTO.md) · Validation evidence: [docs/VALIDATION.md](docs/VALIDATION.md)
