# developer-experience-spec.md — Self-Service & Onboarding

Inherits: platform-spec.md

## 1. DX goals (measurable)
| Metric | Before | Target |
|---|---|---|
| Time to first green pipeline | days | < 30 min |
| Lines of pipeline YAML per repo | ~100+ | <= 20 |
| Lines of Terraform to get baseline infra | ~300+ | ~8 |
| Commands to validate everything locally | many | 1 (`make validate`) |

## 2. Self-service interface
| Task | Command |
|---|---|
| Create service | `make new-service NAME=orders-service TEAM=commerce` |
| Run all checks locally | `make validate` |
| Try infra without cloud | `make localstack EX=ims` |
| Run tests | `make test` |

## 3. Documentation standards
- README top 30 lines: what, quick start, what-you-get.
- `docs/HOWTO.md` is a runnable tutorial; every command tested.
- Diagrams as Mermaid (render in GitHub). ADRs for decisions (Context, Problem, Decision, Alternatives, Trade-offs, Consequences, Rationale).
- Error messages must tell the user how to fix (see `new-service.sh`).

## 4. Onboarding checklist (new team)
1. Run scaffolder. 2. Push to GitHub, enable branch protection. 3. Add repo to `CODEOWNERS` team. 4. Fill `docs/ai-spec.md` service deltas. 5. Open first PR -> CI green. 6. Request AWS OIDC role from platform.

## 5. Feedback loop
PR template, issue templates for module requests, quarterly platform survey, track DORA metrics.

## 6. Acceptance criteria
- [ ] New engineer follows HOWTO unaided and reaches green CI.
- [ ] Every script supports `--help`-grade usage message and fails fast with actionable errors.
