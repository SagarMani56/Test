variable "app_name" {
  type        = string
  description = "Application name (lowercase, hyphenated). Drives all resource names."
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,30}$", var.app_name))
    error_message = "app_name must be 3-31 chars, lowercase letters, digits, hyphens."
  }
}
variable "team" {
  type        = string
  description = "Owning team (used for tagging)."
}
variable "environment" {
  type        = string
  description = "dev | staging | prod"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging or prod."
  }
}
variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "enable_flow_logs" {
  type    = bool
  default = true
}
variable "table_hash_key" {
  type    = string
  default = "id"
}
variable "enable_compute" {
  description = "Create ECR + ECS Fargate service. Disable for local/LocalStack runs."
  type        = bool
  default     = false
}
variable "image_tag" {
  type    = string
  default = "latest"
}
