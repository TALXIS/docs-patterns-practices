terraform {
  required_providers {
    powerplatform = {
      source  = "microsoft/power-platform"
      version = "4.1.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}


provider "powerplatform" {
  use_cli = true
}

provider "azuread" {}

# ──────────────────────────────────────────────
# Org Unit Modules
# ──────────────────────────────────────────────

module "sales_red" {
  source = "./ORGUNITS/SALES/red"
}
