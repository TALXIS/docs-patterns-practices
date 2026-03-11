# ──────────────────────────────────────────────
# Access Package Catalog (shared)
# ──────────────────────────────────────────────

resource "azuread_access_package_catalog" "sales_red" {
  display_name = "${powerplatform_environment_group.sales_red.display_name} Catalog"
  description  = "Access package catalog for the SALES Red environment group"
}

# ──────────────────────────────────────────────
# Access Packages – one per Azure AD group
# ──────────────────────────────────────────────

# --- Users ---

resource "azuread_access_package" "sales_red_users" {
  catalog_id   = azuread_access_package_catalog.sales_red.id
  display_name = "${powerplatform_environment_group.sales_red.display_name} – Users"
  description  = "Access package for SALES Red Users"
}

resource "azuread_access_package_resource_catalog_association" "sales_red_users" {
  catalog_id             = azuread_access_package_catalog.sales_red.id
  resource_origin_id     = azuread_group.sales_red_users.object_id
  resource_origin_system = "AadGroup"
}

resource "azuread_access_package_resource_package_association" "sales_red_users" {
  access_package_id               = azuread_access_package.sales_red_users.id
  catalog_resource_association_id = azuread_access_package_resource_catalog_association.sales_red_users.id
}

# --- Developers ---

resource "azuread_access_package" "sales_red_developers" {
  catalog_id   = azuread_access_package_catalog.sales_red.id
  display_name = "${powerplatform_environment_group.sales_red.display_name} – Developers"
  description  = "Access package for SALES Red Developers"
}

resource "azuread_access_package_resource_catalog_association" "sales_red_developers" {
  catalog_id             = azuread_access_package_catalog.sales_red.id
  resource_origin_id     = azuread_group.sales_red_developers.object_id
  resource_origin_system = "AadGroup"
}

resource "azuread_access_package_resource_package_association" "sales_red_developers" {
  access_package_id               = azuread_access_package.sales_red_developers.id
  catalog_resource_association_id = azuread_access_package_resource_catalog_association.sales_red_developers.id
}

# --- Admins ---

resource "azuread_access_package" "sales_red_admins" {
  catalog_id   = azuread_access_package_catalog.sales_red.id
  display_name = "${powerplatform_environment_group.sales_red.display_name} – Admins"
  description  = "Access package for SALES Red Admins"
}

resource "azuread_access_package_resource_catalog_association" "sales_red_admins" {
  catalog_id             = azuread_access_package_catalog.sales_red.id
  resource_origin_id     = azuread_group.sales_red_admins.object_id
  resource_origin_system = "AadGroup"
}

resource "azuread_access_package_resource_package_association" "sales_red_admins" {
  access_package_id               = azuread_access_package.sales_red_admins.id
  catalog_resource_association_id = azuread_access_package_resource_catalog_association.sales_red_admins.id
}
