resource "powerplatform_environment" "ew_sales_coe_red_1_dev" {
  display_name         = "EW_SALES_COE_RED_1_DEV"
  description          = "Sales Center of Excellence environment – development"
  location             = "europe"
  environment_type     = "Sandbox"
  cadence              = "Moderate"
  environment_group_id = var.environment_group_id
  dataverse = {
    language_code     = "1033"
    currency_code     = "EUR"
    security_group_id = var.security_group_id
  }
}
