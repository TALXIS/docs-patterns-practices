# Get the root business unit for each environment
data "powerplatform_data_records" "root_business_unit" {
  for_each          = var.environment_ids
  environment_id    = each.value
  entity_collection = "businessunits"
  filter            = "parentbusinessunitid eq null"
  select            = ["name"]
}
