variable "name" {
  type        = string
  description = "Service name."
}
variable "image" {
  type        = string
  description = "Full image URI incl. immutable tag."
}
variable "container_port" {
  type    = number
  default = 8000
}
variable "cpu" {
  type    = number
  default = 256
}
variable "memory" {
  type    = number
  default = 512
}
variable "desired_count" {
  type    = number
  default = 2
}
variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "environment" {
  type    = map(string)
  default = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
