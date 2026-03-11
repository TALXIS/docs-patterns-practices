# ──────────────────────────────────────────────
# Azure AD Security Groups
# ──────────────────────────────────────────────

resource "azuread_group" "sales_red_users" {
  display_name     = "SALES – Red Users"
  mail_enabled     = false
  mail_nickname    = "sales-red-users"
  security_enabled = true
}

resource "azuread_group" "sales_red_developers" {
  display_name     = "SALES – Red Developers"
  mail_enabled     = false
  mail_nickname    = "sales-red-developers"
  security_enabled = true
}

resource "azuread_group" "sales_red_admins" {
  display_name     = "SALES – Red Admins"
  mail_enabled     = false
  mail_nickname    = "sales-red-admins"
  security_enabled = true
}
