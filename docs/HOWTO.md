# HOWTO — Build, Validate and Submit the Capstone (step by step)

## 0. Prerequisites (install once)
| Tool | Install (macOS / Ubuntu) |
|---|---|
| Git, Docker | docker.com / `apt install git docker.io docker-compose-v2` |
| Python 3.12 | `brew install python` / `apt install python3 python3-pip` |
| Terraform >= 1.6 | `brew install terraform` / HashiCorp apt repo |
| Trivy | `brew install trivy` / aquasecurity docs |
| Checkov | `pip install checkov` |
| Gitleaks | `brew install gitleaks` / release binary |
| shellcheck, yamllint | `brew install shellcheck yamllint` / `apt install shellcheck yamllint` |

## 1. Create the GitHub repo
Name must be `group<N>-advanced` (e.g. `group7-advanced`).
```bash
unzip group1-advanced.zip && cd group1-advanced
git init -b main && git add -A && git commit -m "feat: initial platform"
gh repo create <org>/group7-advanced --private --source=. --push   # or create on github.com and `git remote add`
```
Replace the placeholder org everywhere:
```bash
grep -rl "SagarMani56/Test" . | xargs sed -i 's|SagarMani56/Test|<org>/group7-advanced|g'   # mac: sed -i ''
```

## 2. Understand the workflow the PDF expects (Spec-Driven AI Engineering)
1. **Business problem** -> read `docs/ai-specifications/platform-spec.md` §1-2.
2. **Domains** -> platform-spec §4 splits into Terraform, Workflows, Repo template, Governance, DX.
3. **Specs** -> the 6 `.md` files (already written; tailor names/orgs/metrics to your group).
4. **AI agent** -> open the repo in Claude Code / Copilot Agent / Cursor and instruct it only with the specs:
   > "Read docs/ai-specifications/platform-spec.md and terraform-modules-spec.md. Implement or improve `infrastructure/modules/network` to satisfy every MUST and acceptance criterion. Run validations and fix failures."
   (Do **not** submit prompts or chat history — the rule says specs are the artifact.)
5. **Review/validate/refactor/secure** -> §3-§7 below.
6. **Test, document, package** -> §8-§9.

## 3. Run the app
```bash
cd app && python -m venv .venv && source .venv/bin/activate
pip install -r requirements-dev.txt
ruff check . && pytest --cov=src --cov-fail-under=80
uvicorn src.main:app --reload     # http://localhost:8000/docs
docker build -t acme-ims . && docker run -p 8000:8000 acme-ims
```

## 4. Terraform validation
```bash
terraform fmt -recursive infrastructure
for d in infrastructure/modules/* infrastructure/examples/*; do (cd $d && terraform init -backend=false && terraform validate); done
checkov -d infrastructure/modules --config-file policies/checkov.yaml
```
Fix any failure (this *is* the "review & secure AI output" step — record what you fixed in `docs/VALIDATION.md`).

## 5. Run Terraform with no cloud (LocalStack)
```bash
make localstack EX=ims            # up -> apply -> outputs -> (enter) -> destroy
# in another terminal while paused:
aws --endpoint-url http://localhost:4566 dynamodb list-tables
aws --endpoint-url http://localhost:4566 s3 ls
```
Repeat with `EX=team-b-orders` to prove reuse.

## 6. Prove reuse (the heart of the capstone)
```bash
make new-service NAME=orders-service TEAM=commerce
cd orders-service/app && pip install -r requirements-dev.txt && pytest
```
Show reviewers: IMS and orders differ only by `app_name`/`team`/`image-name`; pipelines and Terraform are **not** copied.

## 7. Security scans + negative tests
```bash
gitleaks detect --source . -c .gitleaks.toml
trivy fs --severity HIGH,CRITICAL .
```
Negative tests (screenshot each failing, then revert):
```bash
echo 'aws_key = "AKIAIOSFODNN7EXAMPLE1"' > leak.txt && git add leak.txt && gitleaks protect --staged   # must fail
# add to a module: ingress { from_port=22 to_port=22 protocol="tcp" cidr_blocks=["0.0.0.0/0"] }  -> checkov must fail
```

## 8. GitHub Actions
1. Push to `main`; open a PR from a branch. Watch Actions: `ims-ci`, `platform-self-test`.
2. Tag release: `git tag v1.0.0 && git tag v1 && git push --tags` (so `@v1` references resolve).
   > If the repo is private, set *Settings -> Actions -> General -> Access* to allow other repos to use its workflows.
3. Branch protection (Settings -> Branches): require PR, CODEOWNERS review, required checks.
4. If Actions isn't available: files in `.github/workflows/` are still the deliverable; run `act` locally (`brew install act`) or rely on `validate-local.sh`.

## 9. Docs & presentation
- Diagrams: Mermaid in `docs/architecture/architecture.md` (render on GitHub; export to PNG with mermaid.live if needed).
- ADRs: `docs/engineering-decisions/` — edit to reflect your real decisions.
- Deck: `docs/presentation/Acme_IDP_Capstone.pptx` — add screenshots of green pipelines, LocalStack outputs, failing negative tests.

## 10. Submission checklist
- [ ] Repo named `group<N>-advanced`
- [ ] 6 specs present, tailored, committed
- [ ] `make validate` output captured; VALIDATION.md filled
- [ ] Green GitHub Actions screenshot
- [ ] Team-B onboarding demo
- [ ] ADRs, architecture, deck
- [ ] No prompts/chat history in repo (`grep -ri "prompt" docs` to double check)

## 11. Presenting (5-min script)
1. Problem (6 pains) -> 2. Platform vision -> 3. Specs as source of truth -> 4. Live demo: scaffold Team B, show green CI -> 5. Security gates & negative test -> 6. Metrics (100->15 lines YAML; 300->8 lines TF; days->30 min) -> 7. Lessons from validating AI output -> 8. Roadmap (Backstage, policy-as-code, DORA).
