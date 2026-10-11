output "vpc_id" {
  value = module.network.vpc_id
}
output "table_name" {
  value = module.table.table_name
}
output "artifact_bucket" {
  value = module.artifacts.bucket_id
}
output "ecr_url" {
  value = try(module.registry[0].repository_url, null)
}
