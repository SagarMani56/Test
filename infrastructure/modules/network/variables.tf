variable "name" {
  description = "Name prefix for all network resources."
  type        = string
}
variable "cidr_block" {
  description = "VPC CIDR."
  type        = string
  default     = "10.0.0.0/16"
}
variable "azs" {
  description = "Availability zones to use (min 2 recommended)."
  type        = list(string)
}
variable "enable_flow_logs" {
  description = "Enable VPC flow logs to CloudWatch."
  type        = bool
  default     = true
}
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
