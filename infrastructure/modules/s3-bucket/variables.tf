variable "bucket_name" {
  type        = string
  description = "Globally unique bucket name."
}
variable "enable_lifecycle" {
  type        = bool
  default     = true
  description = "Manage the lifecycle configuration. Keep true on real AWS; set false only for LocalStack runs."
}
variable "tags" {
  type    = map(string)
  default = {}
}
