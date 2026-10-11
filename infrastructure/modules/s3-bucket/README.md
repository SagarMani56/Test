# module: s3-bucket

Part of the Acme Platform Terraform library. Standards (inputs/outputs, tagging, security
defaults) are defined in `docs/ai-specifications/terraform-modules-spec.md`.

```hcl
module "s3-bucket" {
  source = "git::https://github.com/<org>/group1-advanced.git//infrastructure/modules/s3-bucket?ref=v1.0.0"
  # see variables.tf
}
```
