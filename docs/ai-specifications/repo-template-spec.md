# repo-template-spec.md — Standard Repository Template

Inherits: platform-spec.md

## 1. Problem
Teams use different layouts -> hard to move engineers, hard to automate.

## 2. Standard layout (every repo)
```
README.md              # purpose, quick start, what-you-get table
app/                   # source, tests/, Dockerfile, requirements*.txt
infrastructure|infra/  # Terraform: ONLY platform module calls
.github/workflows/     # caller workflows only
docs/
  architecture/        # diagrams (Mermaid)
  ai-specifications/   # service spec (inherits platform specs)
  engineering-decisions/  # ADRs
  presentation/
CODEOWNERS, .gitignore, .gitleaks.toml
```

## 3. Scaffolder contract (`scripts/new-service.sh`)
- Inputs: `<service-name> <team> [target-dir]`; env `PLATFORM_REPO`.
- Validates name `^[a-z][a-z0-9-]{2,30}$`; refuses existing target dir (idempotent-safe).
- Replaces placeholders `{{SERVICE_NAME}} {{TEAM}} {{PLATFORM_REPO}}`; leaves none behind.
- Output must pass its own tests and build its own Docker image immediately.

## 4. Template rules
- Template app = health endpoint + test + Dockerfile (non-root, healthcheck, slim image).
- Dockerfile: pinned base major, non-root UID, no secrets, `.dockerignore`.
- Template contains **no** pipeline logic — only `uses:` to reusable workflows.
- Template contains **no** raw AWS resources — only `app-platform`.

## 5. Acceptance criteria
- [ ] `platform-self-test` job `second-team-onboarding` scaffolds, tests and builds a new service.
- [ ] grep for `{{` in generated repo returns nothing.
- [ ] New repo reaches green CI without manual edits.

## 6. AI agent rules
Per-service `docs/ai-spec.md` must start with `Inherits:` and list only service-specific deltas.
