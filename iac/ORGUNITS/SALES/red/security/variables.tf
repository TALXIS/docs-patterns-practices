variable "environment_ids" {
  type        = map(string)
  description = "Map of environment name to environment ID (keys: dev, uat, prod)"
}

variable "aad_group_ids" {
  type        = map(string)
  description = "Map of team name to Azure AD group object ID (keys: users, developers, admins)"
}
