resource "azurerm_user_assigned_identity" "control_plane" {
  location            = var.location
  name                = "${var.prefix}-control-plane"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_user_assigned_identity" "worker_plane" {
  location            = var.location
  name                = "${var.prefix}-worker-plane"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_role_assignment" "control_plane_vault_auth" {
  principal_id       = azurerm_user_assigned_identity.control_plane.principal_id
  role_definition_id = data.azurerm_role_definition.hashicorp_vault.id
  scope              = data.azurerm_resource_group.this.id
}

resource "azurerm_role_assignment" "control_plane_acr_read" {
  principal_id       = azurerm_user_assigned_identity.control_plane.principal_id
  role_definition_id = data.azurerm_role_definition.acr_pull.role_definition_id
  scope              = data.azurerm_resource_group.this.id
}

resource "azurerm_role_assignment" "control_plane_key_vault_user" {
  principal_id       = azurerm_user_assigned_identity.control_plane.principal_id
  role_definition_id = data.azurerm_role_definition.key_vault_user.role_definition_id
  scope              = data.azurerm_resource_group.this.id
}

resource "azurerm_role_assignment" "worker_plane_acr_read" {
  principal_id       = azurerm_user_assigned_identity.worker_plane.principal_id
  role_definition_id = data.azurerm_role_definition.acr_pull.role_definition_id
  scope              = data.azurerm_resource_group.this.id
}

// builtin roles

data "azurerm_role_definition" "acr_pull" {
  name  = "AcrPull"
  scope = data.azurerm_resource_group.this.id
}

data "azurerm_role_definition" "hashicorp_vault" {
  name  = "Owner"
  scope = data.azurerm_subscription.this.id
}

data "azurerm_role_definition" "key_vault_user" {
  name  = "Key Vault Crypto User"
  scope = data.azurerm_resource_group.this.id
}
