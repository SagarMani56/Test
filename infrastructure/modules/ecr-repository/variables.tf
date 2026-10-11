variable "name" {
  type        = string
  description = "Repository name."
}
variable "tags" {
  type    = map(string)
  default = {}
}
