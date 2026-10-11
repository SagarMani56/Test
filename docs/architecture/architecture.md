# Platform Architecture

## 1. Context
```mermaid
flowchart LR
  Dev[App Developer] -->|make new-service| Scaf[Scaffolder]
  Scaf --> Repo[(New service repo)]
  Repo -->|uses @v1| WF[Reusable Workflows]
  Repo -->|module ?ref=v1| TF[Terraform Module Library]
  WF --> Sec[Gitleaks / Trivy / Checkov]
  WF --> Reg[(GHCR / ECR)]
  TF --> AWS[(AWS or LocalStack)]
  Specs[AI Specs] -.guide.-> Agent[AI Coding Agent] -.generates.-> Repo
```

## 2. Platform repository components
```mermaid
flowchart TB
  subgraph Platform[group1-advanced]
    S[docs/ai-specifications x6]
    W[.github/workflows reusable-*]
    M[infrastructure/modules x6]
    T[templates/service-template]
    P[policies/ checkov gitleaks trivy]
    X[scripts/ new-service validate-local]
  end
  S --> W & M & T & P & X
```

## 3. CI/CD flow
```mermaid
flowchart LR
  PR[Pull Request] --> L[ruff] --> U[pytest + coverage gate] --> G[Gitleaks]
  U --> B[docker build] --> TF[Trivy fs] --> TI[Trivy image]
  PR --> F[tf fmt/validate] --> CK[Checkov] --> LS[LocalStack apply]
  TI & CK --> Merge{All green?}
  Merge -->|yes| Rel[Tag v* -> release GHCR + SBOM]
```

## 4. Infrastructure (app-platform module)
```mermaid
flowchart TB
  subgraph VPC
    Pub[Public subnets x2] --- IGW
    Priv[Private subnets x2] --> ECS[ECS Fargate service*]
  end
  ECS --> DDB[(DynamoDB, PITR+SSE)]
  ECS --> S3[(S3 private, versioned)]
  ECR[(ECR immutable*)] --> ECS
  ECS --> CW[CloudWatch Logs 365d]
```
\* created when `enable_compute = true`.

## 5. Onboarding sequence
```mermaid
sequenceDiagram
  actor D as Developer
  participant S as new-service.sh
  participant G as GitHub
  participant P as Platform workflows
  D->>S: name + team
  S-->>D: repo with app, infra, ci.yml, ai-spec
  D->>G: push, open PR
  G->>P: workflow_call @v1
  P-->>G: lint/test/scan results
  G-->>D: green check, merge
```

## 6. Versioning & upgrade model
Platform releases `v1.x` (non-breaking) -> teams auto-benefit via `@v1`. Breaking -> `v2`, migration note + ADR; Dependabot proposes bumps.
