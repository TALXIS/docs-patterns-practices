# ──────────────────────────────────────────────
# Data Loss Prevention Policy
# ──────────────────────────────────────────────

data "powerplatform_connectors" "all_connectors" {}

locals {
  sales_red_business_connectors = toset([
    {
      id                           = "/providers/Microsoft.PowerApps/apis/shared_sharepointonline"
      action_rules                 = []
      default_action_rule_behavior = ""
      endpoint_rules               = []
    },
    {
      id                           = "/providers/Microsoft.PowerApps/apis/shared_office365"
      action_rules                 = []
      default_action_rule_behavior = ""
      endpoint_rules               = []
    },
    {
      id                           = "/providers/Microsoft.PowerApps/apis/shared_approvals"
      action_rules                 = []
      default_action_rule_behavior = ""
      endpoint_rules               = []
    },
  ])

  sales_red_non_business_connectors = toset([
    for conn in data.powerplatform_connectors.all_connectors.connectors : {
      id                           = conn.id
      default_action_rule_behavior = ""
      action_rules                 = []
      endpoint_rules               = []
    }
    if conn.unblockable == true &&
    !contains([for c in local.sales_red_business_connectors : c.id], conn.id)
  ])

  sales_red_blocked_connectors = toset([
    for conn in data.powerplatform_connectors.all_connectors.connectors : {
      id                           = conn.id
      default_action_rule_behavior = ""
      action_rules                 = []
      endpoint_rules               = []
    }
    if conn.unblockable == false &&
    !contains([for c in local.sales_red_business_connectors : c.id], conn.id)
  ])
}

resource "powerplatform_data_loss_prevention_policy" "sales_red" {
  display_name                      = "SALES Red – DLP Policy"
  default_connectors_classification = "Blocked"
  environment_type                  = "OnlyEnvironments"
  environments                      = module.environments.environment_ids

  business_connectors     = local.sales_red_business_connectors
  non_business_connectors = local.sales_red_non_business_connectors
  blocked_connectors      = local.sales_red_blocked_connectors

  custom_connectors_patterns = toset([
    {
      order            = 1
      host_url_pattern = "*"
      data_group       = "Blocked"
    }
  ])
}
