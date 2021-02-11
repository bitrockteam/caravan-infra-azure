resource "azurerm_role_assignment" "control_plane_vault_auth" {
  count = var.control_plane_instance_count

  principal_id       = azurerm_linux_virtual_machine.control_plane[count.index].identity[0].principal_id
  role_definition_id = data.azurerm_role_definition.hashicorp_vault.id
  scope              = data.azurerm_resource_group.this.id
}

resource "azurerm_role_assignment" "control_plane_acr_read" {
  count = var.control_plane_instance_count

  principal_id       = azurerm_linux_virtual_machine.control_plane[count.index].identity[0].principal_id
  role_definition_id = data.azurerm_role_definition.acr_pull.role_definition_id
  scope              = data.azurerm_resource_group.this.id
}

resource "azurerm_role_assignment" "control_plane_key_vault_user" {
  count = var.control_plane_instance_count

  principal_id       = azurerm_linux_virtual_machine.control_plane[count.index].identity[0].principal_id
  role_definition_id = data.azurerm_role_definition.key_vault_user.role_definition_id
  scope              = data.azurerm_resource_group.this.id
}

resource "azurerm_role_assignment" "worker_plane_acr_read" {
  count = length(azurerm_linux_virtual_machine_scale_set.worker_plane.identity)

  principal_id       = azurerm_linux_virtual_machine_scale_set.worker_plane.identity[count.index].principal_id
  role_definition_id = data.azurerm_role_definition.acr_pull.role_definition_id
  scope              = data.azurerm_resource_group.this.id
}

resource "azurerm_role_assignment" "monitoring_acr_read" {
  count = var.enable_monitoring ? 1 : 0

  principal_id       = azurerm_linux_virtual_machine.monitoring[count.index].identity[0].principal_id
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
