# ──────────────────────────────────────────────
# Security Roles: "App Opener" and "System admin"
# Created in each environment (DEV, UAT, PROD)
# ──────────────────────────────────────────────

locals {
  roles = {
    for pair in setproduct(keys(var.environment_ids), ["App Opener", "System admin"]) :
    "${pair[0]}_${replace(lower(pair[1]), " ", "_")}" => {
      env_key   = pair[0]
      role_name = pair[1]
    }
  }
}

resource "powerplatform_data_record" "role" {
  for_each           = local.roles
  environment_id     = var.environment_ids[each.value.env_key]
  table_logical_name = "role"
  columns = {
    name = each.value.role_name
    businessunitid = {
      table_logical_name = "businessunit"
      data_record_id     = data.powerplatform_data_records.root_business_unit[each.value.env_key].rows[0]["businessunitid"]
    }
  }
}
