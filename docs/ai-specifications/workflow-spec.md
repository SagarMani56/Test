# workflow-spec.md — Reusable GitHub Actions

Inherits: platform-spec.md, governance-spec.md

## 1. Design
Platform repo owns **reusable workflows** (`on: workflow_call`). App repos own ~15-line **caller** workflows.

```
caller (app repo) --uses--> reusable-ci.yml | reusable-terraform.yml | reusable-release.yml
```

## 2. Catalogue
| Workflow | Stages | Inputs |
|---|---|---|
| `reusable-ci.yml` | ruff -> pytest+coverage gate -> Gitleaks -> docker build -> Trivy fs -> Trivy image | working-directory, python-version, image-name, coverage-threshold, trivy-severity |
| `reusable-terraform.yml` | fmt -> init/validate -> Checkov -> (opt) LocalStack apply/destroy | working-directory, terraform-version, localstack-apply |
| `reusable-release.yml` | buildx -> push GHCR -> SBOM + provenance | working-directory, image-name |
| `platform-self-test.yml` | yamllint, shellcheck, module matrix, Team-B scaffold test | — |

## 3. Standards (MUST)
1. Top-level `permissions: contents: read`; elevate per-job only (release needs `packages: write`).
2. `concurrency` with cancel-in-progress on CI.
3. `timeout-minutes` on every job.
4. Third-party actions pinned to a version tag minimum; prefer commit SHA in production (Dependabot updates them).
5. No secrets in `inputs`. Use `secrets: inherit` or OIDC (`id-token: write`), never long-lived AWS keys.
6. Fail closed: security scan failures (HIGH/CRITICAL, secrets, Checkov) block merge.
7. Caches (`setup-python cache: pip`) to keep CI < 5 min.
8. Reusable workflows versioned by tag; callers reference `@v1`.
9. Branch protection requires the caller job names as status checks.

## 4. Acceptance criteria
- [ ] Caller workflow <= 20 lines.
- [ ] Both IMS and a scaffolded service use the same reusable workflow with different inputs.
- [ ] A seeded fake secret or a HIGH CVE fails the pipeline (negative test, see HOWTO §9).

## 5. AI agent rules
Generate YAML that passes `yamllint`. Never inline shell logic > 10 lines; put it in `scripts/`.
