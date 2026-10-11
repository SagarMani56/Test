terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "platform" {
  source         = "git::https://github.com/{{PLATFORM_REPO}}.git//infrastructure/modules/app-platform?ref=v1"
  app_name       = "{{SERVICE_NAME}}"
  team           = "{{TEAM}}"
  environment    = "dev"
  enable_compute = false
}
