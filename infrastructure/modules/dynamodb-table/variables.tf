variable "name" {
  type        = string
  description = "Table name."
}
variable "hash_key" {
  type        = string
  description = "Partition key attribute name."
}
variable "hash_key_type" {
  type        = string
  default     = "S"
  description = "S, N or B."
}
variable "tags" {
  type    = map(string)
  default = {}
}
