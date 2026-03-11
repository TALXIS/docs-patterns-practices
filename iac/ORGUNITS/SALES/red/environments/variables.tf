variable "environment_group_id" {
  type        = string
  description = "ID of the parent environment group"
}

variable "security_group_id" {
  type        = string
  description = "ID of the security group to assign to the environment"
}
