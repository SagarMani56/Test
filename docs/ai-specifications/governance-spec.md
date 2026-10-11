# governance-spec.md — Security, Compliance & Quality Gates

Inherits: platform-spec.md

## 1. Principles
Shift-left, fail closed, least privilege, every exception justified + owned + expiring.

## 2. Control matrix
| Control | Tool | Where | Blocks merge? |
|---|---|---|---|
| Secret detection | Gitleaks | CI (full history) + pre-commit | Yes |
| Dependency/image CVEs | Trivy (fs + image) HIGH,CRITICAL | CI | Yes (ignore-unfixed) |
| IaC misconfiguration | Checkov | CI + local | Yes |
| IaC format/validity | terraform fmt/validate | CI | Yes |
| Code quality | ruff | CI | Yes |
| Test coverage | pytest-cov >= 80% | CI | Yes |
| Supply chain | SBOM + provenance on release; Dependabot | Release | n/a |
| Ownership | CODEOWNERS | PRs | Review required |

## 3. Access & secrets
- AWS auth from CI via **GitHub OIDC -> IAM role**, no static keys.
- Secrets only in GitHub Secrets / AWS Secrets Manager; never in repo, tfvars or images.
- LocalStack dummy creds (`test`) are allow-listed in `.gitleaks.toml` only.

## 4. Runtime baseline
Non-root containers, read-only root FS on ECS, private subnets, no public IPs, encrypted at rest, 365-day log retention.

## 5. Branch protection (set on every repo)
Require PR, 1+ approval (CODEOWNERS), required status checks, linear history, no force-push, signed commits recommended.

## 6. Exception process
Skip a check only via `policies/checkov.yaml` or `.trivyignore` with: justification, owner, expiry date, ADR/ticket reference. Platform + Security CODEOWNERS approve.

## 7. AI-generated code policy
1. Human reviews every line before merge (PR checklist item).
2. AI output is subject to the **same** gates; no bypass.
3. Specs are versioned artifacts; prompts/chat logs are not submitted or stored.
4. Check for hallucinated packages/actions/resources — verify each exists and is pinned.

## 8. Acceptance criteria
- [ ] Negative tests: injected fake AWS key -> Gitleaks fails; `0.0.0.0/0` SSH rule -> Checkov fails.
- [ ] All skips in repo have justification comments.
