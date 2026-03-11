output "dev_environment_id" {
  description = "ID of the DEV environment"
  value       = powerplatform_environment.ew_sales_coe_red_1_dev.id
}

output "uat_environment_id" {
  description = "ID of the UAT environment"
  value       = powerplatform_environment.ew_sales_coe_red_1_uat.id
}

output "prod_environment_id" {
  description = "ID of the PROD environment"
  value       = powerplatform_environment.ew_sales_coe_red_1_prod.id
}

output "environment_ids" {
  description = "List of all environment IDs in this group"
  value = [
    powerplatform_environment.ew_sales_coe_red_1_dev.id,
    powerplatform_environment.ew_sales_coe_red_1_uat.id,
    powerplatform_environment.ew_sales_coe_red_1_prod.id,
  ]
}
