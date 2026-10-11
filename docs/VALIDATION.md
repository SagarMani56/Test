# Validation Report

Rule: *"You are responsible for validating every AI-generated output."* Evidence below.
Fill the **Your result** column when you run each command on your machine; paste screenshots in `docs/presentation/`.

| # | Check | Command | Status in authoring environment | Your result |
|---|---|---|---|---|
| 1 | App lint + tests + coverage >= 80% | `cd app && ruff check . && pytest --cov=src --cov-fail-under=80` | PASS (5 tests, 91% coverage) | |
| 2 | Scaffolder creates service, no leftover placeholders | `scripts/new-service.sh orders-service commerce /tmp/o` | PASS | |
| 3 | Scaffolded service tests pass | `cd /tmp/o/app && pytest` | PASS | |
| 4 | Scaffolder rejects bad name | `scripts/new-service.sh BAD_Name x` | PASS (exit 1, clear message) | |
| 5 | Workflow YAML parses | `python -c "import yaml,glob;[yaml.safe_load(open(f)) for f in glob.glob('.github/workflows/*.yml')]"` | PASS | |
| 6 | Shell scripts syntax | `bash -n scripts/*.sh` (+ `shellcheck`) | PASS (`bash -n`) | |
| 7 | Terraform fmt/validate | `terraform fmt -check -recursive infrastructure` + validate each dir | **RUN ON YOUR MACHINE** (needs provider download) | |
| 8 | Checkov | `checkov -d infrastructure/modules --config-file policies/checkov.yaml` | **RUN ON YOUR MACHINE** | |
| 9 | Trivy / Gitleaks | `trivy fs .` / `gitleaks detect` | **RUN ON YOUR MACHINE** | |
| 10 | LocalStack apply | `make localstack EX=ims` | **RUN ON YOUR MACHINE** (needs Docker) | |
| 11 | GitHub Actions run green | push + open PR | **RUN ON GITHUB** | |

## Review notes / issues you should expect and fix (this is part of "validate AI output")
- Checkov may flag extra checks (e.g. CKV2_AWS_*); fix the code or add a *justified* skip.
- `terraform fmt` may rewrite alignment; run `terraform fmt -recursive` then commit.
- If LocalStack rejects a resource (flow logs, some EC2 attributes), keep `enable_flow_logs=false` for local.
- Pin GitHub Actions to commit SHAs before production use.
- Replace `SagarMani56/Test` with your real `<org>/<repo>` and create a `v1` tag.
