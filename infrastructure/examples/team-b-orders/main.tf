terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

variable "use_localstack" {
  type    = bool
  default = true
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = var.use_localstack ? "test" : null
  secret_key                  = var.use_localstack ? "test" : null
  skip_credentials_validation = var.use_localstack
  skip_metadata_api_check     = var.use_localstack
  skip_requesting_account_id  = var.use_localstack
  s3_use_path_style           = var.use_localstack

  dynamic "endpoints" {
    for_each = var.use_localstack ? [1] : []
    content {
      ec2      = "http://localhost:4566"
      s3       = "http://localhost:4566"
      dynamodb = "http://localhost:4566"
      iam      = "http://localhost:4566"
      logs     = "http://localhost:4566"
      sts      = "http://localhost:4566"
    }
  }
}

# The ENTIRE onboarding for this app is this one module call.
module "platform" {
  source           = "../../modules/app-platform"
  app_name         = "orders"
  team             = "commerce"
  environment      = "dev"
  enable_flow_logs = false # LocalStack community: skip flow logs
  enable_compute   = false # ECR/ECS are validated + planned on real AWS only

  # LocalStack: the provider's lifecycle-rule wait can time out. Real AWS keeps the default (true).
  enable_s3_lifecycle = !var.use_localstack
}

output "table_name" {
  value = module.platform.table_name
}
output "artifact_bucket" {
  value = module.platform.artifact_bucket
}
