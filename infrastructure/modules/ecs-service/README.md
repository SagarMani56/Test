# module: ecs-service

Part of the Acme Platform Terraform library. Standards (inputs/outputs, tagging, security
defaults) are defined in `docs/ai-specifications/terraform-modules-spec.md`.

```hcl
module "ecs-service" {
  source = "git::https://github.com/<org>/group1-advanced.git//infrastructure/modules/ecs-service?ref=v1.0.0"
  # see variables.tf
}
```
