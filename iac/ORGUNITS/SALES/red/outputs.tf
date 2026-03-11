output "environment_group_id" {
  description = "ID of the SALES Red environment group"
  value       = powerplatform_environment_group.sales_red.id
}

output "dev_environment_id" {
  description = "ID of the DEV environment"
  value       = module.environments.dev_environment_id
}

output "uat_environment_id" {
  description = "ID of the UAT environment"
  value       = module.environments.uat_environment_id
}

output "prod_environment_id" {
  description = "ID of the PROD environment"
  value       = module.environments.prod_environment_id
}

output "users_group_id" {
  description = "Object ID of the SALES Red Users Azure AD group"
  value       = azuread_group.sales_red_users.object_id
}

output "developers_group_id" {
  description = "Object ID of the SALES Red Developers Azure AD group"
  value       = azuread_group.sales_red_developers.object_id
}

output "admins_group_id" {
  description = "Object ID of the SALES Red Admins Azure AD group"
  value       = azuread_group.sales_red_admins.object_id
}
