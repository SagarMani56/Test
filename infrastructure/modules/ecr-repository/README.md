# module: ecr-repository

Part of the Acme Platform Terraform library. Standards (inputs/outputs, tagging, security
defaults) are defined in `docs/ai-specifications/terraform-modules-spec.md`.

```hcl
module "ecr-repository" {
  source = "git::https://github.com/<org>/group1-advanced.git//infrastructure/modules/ecr-repository?ref=v1.0.0"
  # see variables.tf
}
```
