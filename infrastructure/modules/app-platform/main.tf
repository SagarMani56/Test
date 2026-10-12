locals {
  prefix = "${var.app_name}-${var.environment}"
  tags = {
    app         = var.app_name
    team        = var.team
    environment = var.environment
    managed_by  = "terraform"
    platform    = "acme-idp"
  }
}

module "network" {
  source           = "../network"
  name             = local.prefix
  azs              = var.azs
  enable_flow_logs = var.enable_flow_logs
  tags             = local.tags
}

module "table" {
  source   = "../dynamodb-table"
  name     = "${local.prefix}-data"
  hash_key = var.table_hash_key
  tags     = local.tags
}

module "artifacts" {
  source           = "../s3-bucket"
  bucket_name      = "${local.prefix}-artifacts"
  enable_lifecycle = var.enable_s3_lifecycle
  tags             = local.tags
}

module "registry" {
  count  = var.enable_compute ? 1 : 0
  source = "../ecr-repository"
  name   = local.prefix
  tags   = local.tags
}

module "service" {
  count       = var.enable_compute ? 1 : 0
  source      = "../ecs-service"
  name        = local.prefix
  image       = "${module.registry[0].repository_url}:${var.image_tag}"
  vpc_id      = module.network.vpc_id
  subnet_ids  = module.network.private_subnet_ids
  environment = { TABLE_NAME = module.table.table_name }
  tags        = local.tags
}
