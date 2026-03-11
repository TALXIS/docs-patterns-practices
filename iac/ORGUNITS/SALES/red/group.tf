# ──────────────────────────────────────────────
# SALES – Red  (production / business-critical apps)
# High business impact / strict governance
# ──────────────────────────────────────────────

resource "powerplatform_environment_group" "sales_red" {
  display_name = "SALES – Red Environment Group"
  description  = "Sales production and business-critical apps – high business impact"
}

# ──────────────────────────────────────────────
# Child module – individual environments
# ──────────────────────────────────────────────

module "environments" {
  source               = "./environments"
  environment_group_id = powerplatform_environment_group.sales_red.id
  security_group_id    = azuread_group.sales_red_users.object_id
}

# ──────────────────────────────────────────────
# Child module – security (roles & teams)
# ──────────────────────────────────────────────

module "security" {
  source = "./security"

  environment_ids = {
    dev  = module.environments.dev_environment_id
    uat  = module.environments.uat_environment_id
    prod = module.environments.prod_environment_id
  }

  aad_group_ids = {
    users      = azuread_group.sales_red_users.object_id
    developers = azuread_group.sales_red_developers.object_id
    admins     = azuread_group.sales_red_admins.object_id
  }
}
