resource "powerplatform_environment" "ew_sales_coe_red_1_prod" {
  display_name         = "EW_SALES_COE_RED_1_PROD"
  description          = "Sales Center of Excellence environment – business critical"
  location             = "europe"
  environment_type     = "Production"
  cadence              = "Moderate"
  environment_group_id = var.environment_group_id
  dataverse = {
    language_code     = "1033"
    currency_code     = "EUR"
    security_group_id = var.security_group_id
  }
}

resource "powerplatform_managed_environment" "ew_sales_coe_red_1_prod" {
  environment_id                     = powerplatform_environment.ew_sales_coe_red_1_prod.id
  is_usage_insights_disabled         = false
  is_group_sharing_disabled          = true
  limit_sharing_mode                 = "ExcludeSharingToSecurityGroups"
  max_limit_user_sharing             = 5
  solution_checker_mode              = "Block"
  suppress_validation_emails         = false
  power_automate_is_sharing_disabled = true
  copilot_limit_sharing_mode         = "ExcludeSharingToSecurityGroups"
  copilot_max_limit_user_sharing     = 5
}
