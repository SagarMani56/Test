# platform-spec.md — Internal Developer Platform (IDP)

> Master spec. All other specs inherit from this. An AI agent MUST read this first.

## 1. Context
Acme Retail has many teams, each hand-building pipelines, Terraform and repo layouts. Pain: duplicate
pipelines, duplicate Terraform, inconsistent repos, inconsistent AI specs, long onboarding, high maintenance.

## 2. Goal
Turn the single-app IMS solution into a **platform** that a new team adopts in < 1 day with < 20 lines of
config, getting CI/CD, security scanning, IaC and AI-spec scaffolding by default.

## 3. Personas
| Persona | Need |
|---|---|
| App developer | `new-service.sh` -> green pipeline in minutes |
| Platform engineer | One place to fix/upgrade pipelines & infra |
| Security engineer | Non-bypassable scans, auditable exceptions |

## 4. Engineering domains (each has its own spec)
| Domain | Spec | Deliverable |
|---|---|---|
| Infrastructure | terraform-modules-spec.md | `infrastructure/modules/*` |
| CI/CD | workflow-spec.md | `.github/workflows/reusable-*.yml` |
| Repo standards | repo-template-spec.md | `templates/service-template` + scaffolder |
| Security & policy | governance-spec.md | `policies/*`, CODEOWNERS |
| Developer experience | developer-experience-spec.md | scripts, docs, Makefile |

## 5. Architecture requirements
- R1: "Golden path" = default; escape hatches allowed but documented (ADR).
- R2: Reuse via **versioned** references (`@v1`, `?ref=v1`), never `@main`.
- R3: Everything runs locally without a cloud account (Docker, LocalStack).
- R4: Secure by default: least privilege, encryption, no secrets in git, scans block merges.
- R5: Convention over configuration: inputs have safe defaults; only app-specific values are required.

## 6. Non-functional requirements
Reproducible, idempotent, documented, observable (logs/retention), cost-aware (pay-per-request, lifecycle policies).

## 7. Acceptance criteria (the platform is "done" when)
- [ ] A second app (Team B) is onboarded by script + 1 module call with **zero** copy-pasted pipeline/Terraform.
- [ ] `scripts/validate-local.sh` passes on a clean machine.
- [ ] Every module passes fmt, validate, Checkov; examples apply on LocalStack.
- [ ] Every workflow is reusable (`workflow_call`) and consumed by >= 2 callers.
- [ ] ADRs exist for each major decision.

## 8. Constraints for the AI agent
- Output only files in the repository structure defined here; do not invent new top-level folders.
- Never hardcode credentials, account IDs or regions in modules (variables only).
- After generation: run `validate-local.sh`, fix failures, and list any assumptions in the PR.

## 9. Out of scope
Multi-cloud, Kubernetes operators, a UI portal (Backstage) — see ADR-005 for future direction.
