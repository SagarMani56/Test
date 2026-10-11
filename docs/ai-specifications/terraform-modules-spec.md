# terraform-modules-spec.md — Reusable Terraform Library

Inherits: platform-spec.md

## 1. Module catalogue
| Module | Purpose | Key inputs | Key outputs |
|---|---|---|---|
| `network` | VPC, 2+ AZ public/private subnets, IGW, default SG locked, flow logs | name, azs, cidr_block | vpc_id, subnet ids |
| `dynamodb-table` | On-demand table, PITR, SSE | name, hash_key | table_name/arn |
| `s3-bucket` | Private, versioned, encrypted, lifecycle | bucket_name | bucket_id/arn |
| `ecr-repository` | Immutable tags, scan-on-push, retention | name | repository_url |
| `ecs-service` | Fargate service, least-priv IAM, log group, SG | name, image, vpc_id, subnet_ids | service/cluster name |
| `app-platform` | **Composite golden path** composing all of the above | app_name, team, environment | table_name, bucket, ecr_url |

## 2. Standards (MUST)
1. Layout per module: `main.tf variables.tf outputs.tf versions.tf README.md`.
2. Pin `required_version >= 1.6` and provider `~> 5.60`.
3. Every variable has `type` and `description`; validate inputs where a bad value is plausible (`app_name`, `environment`).
4. All resources accept/propagate `tags`; mandatory tags: `app, team, environment, managed_by, platform`.
5. Security defaults ON and not required from callers: encryption, public-access block, immutable tags, PITR, no open ingress, `assign_public_ip=false`.
6. No provider blocks in modules. No hardcoded regions/accounts.
7. Optional components gated by boolean (`enable_compute`, `enable_flow_logs`) using `count`.
8. Names derive from `${app_name}-${environment}` to avoid collisions across teams.
9. IAM: no `*` actions/resources; each role has a single trust principal.
10. Release via git tags (`v1.2.0`), consumed with `?ref=`. Breaking change => major bump + ADR.

## 3. Reuse proof
`infrastructure/examples/ims` and `examples/team-b-orders` differ **only** in `app_name` and `team`.

## 4. Testing
- `terraform fmt -check`, `terraform validate` on every module (CI matrix).
- Checkov with `policies/checkov.yaml`; each skip justified inline.
- `terraform apply` on LocalStack for examples (S3, DynamoDB, VPC). ECR/ECS: validate + Checkov only.

## 5. Acceptance criteria
- [ ] Zero Checkov failures except documented skips.
- [ ] Onboarding a new app = 1 module block.
- [ ] `terraform destroy` leaves nothing behind.

## 6. AI agent rules
Prefer `aws_*_configuration` split resources (AWS provider v5 pattern). Never use deprecated inline `acl`/`versioning` blocks.
