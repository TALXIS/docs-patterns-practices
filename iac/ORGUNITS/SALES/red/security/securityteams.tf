# ──────────────────────────────────────────────
# Security Teams per environment
# Each team is linked to its Azure AD group and
# assigned the appropriate security role(s).
#
# Role assignment matrix:
#   DEV:  Users=[]              Developers=[System admin]  Admins=[System admin]
#   UAT:  Users=[]              Developers=[System admin]  Admins=[System admin]
#   PROD: Users=[App Opener]    Developers=[]              Admins=[System admin]
# ──────────────────────────────────────────────

locals {
  teams = {
    # --- DEV ---
    dev_users = {
      env_key     = "dev"
      team_name   = "Users"
      description = "Users team – DEV"
      aad_key     = "users"
      roles       = []
    }
    dev_developers = {
      env_key     = "dev"
      team_name   = "Developers"
      description = "Developers team – DEV"
      aad_key     = "developers"
      roles       = ["dev_system_admin"]
    }
    dev_admins = {
      env_key     = "dev"
      team_name   = "Admins"
      description = "Admins team – DEV"
      aad_key     = "admins"
      roles       = ["dev_system_admin"]
    }

    # --- UAT ---
    uat_users = {
      env_key     = "uat"
      team_name   = "Users"
      description = "Users team – UAT"
      aad_key     = "users"
      roles       = []
    }
    uat_developers = {
      env_key     = "uat"
      team_name   = "Developers"
      description = "Developers team – UAT"
      aad_key     = "developers"
      roles       = ["uat_system_admin"]
    }
    uat_admins = {
      env_key     = "uat"
      team_name   = "Admins"
      description = "Admins team – UAT"
      aad_key     = "admins"
      roles       = ["uat_system_admin"]
    }

    # --- PROD ---
    prod_users = {
      env_key     = "prod"
      team_name   = "Users"
      description = "Users team – PROD"
      aad_key     = "users"
      roles       = ["prod_app_opener"]
    }
    prod_developers = {
      env_key     = "prod"
      team_name   = "Developers"
      description = "Developers team – PROD"
      aad_key     = "developers"
      roles       = []
    }
    prod_admins = {
      env_key     = "prod"
      team_name   = "Admins"
      description = "Admins team – PROD"
      aad_key     = "admins"
      roles       = ["prod_system_admin"]
    }
  }
}

resource "powerplatform_data_record" "team" {
  for_each           = local.teams
  environment_id     = var.environment_ids[each.value.env_key]
  table_logical_name = "team"
  columns = {
    name                          = each.value.team_name
    description                   = each.value.description
    teamtype                      = 0 # AAD Security Group
    azureactivedirectoryobjectid  = var.aad_group_ids[each.value.aad_key]

    teamroles_association = [
      for role_key in each.value.roles : {
        table_logical_name = "role"
        data_record_id     = powerplatform_data_record.role[role_key].id
      }
    ]
  }
}
