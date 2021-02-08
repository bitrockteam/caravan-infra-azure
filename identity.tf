resource "azurerm_user_assigned_identity" "control_plane" {
  location            = var.location
  name                = "${var.prefix}-control-plane-identity"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_user_assigned_identity" "worker_plane" {
  location            = var.location
  name                = "${var.prefix}-worker-plane-identity"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_role_assignment" "control_plane_vault_auth" {
  principal_id       = azurerm_user_assigned_identity.control_plane.principal_id
  role_definition_id = data.azurerm_role_definition.virtual_machine_user.id
  scope              = data.azurerm_resource_group.this.id
}

resource "azurerm_role_assignment" "control_plane_acr_read" {
  principal_id       = azurerm_user_assigned_identity.control_plane.principal_id
  role_definition_id = data.azurerm_role_definition.acr_pull.role_definition_id
  scope              = data.azurerm_resource_group.this.id
}

resource "azurerm_role_assignment" "worker_plane_acr_read" {
  principal_id       = azurerm_user_assigned_identity.worker_plane.principal_id
  role_definition_id = data.azurerm_role_definition.acr_pull.role_definition_id
  scope              = data.azurerm_resource_group.this.id
}

// builtin roles

data "azurerm_role_definition" "acr_pull" {
  name = "AcrPull"
}

data "azurerm_role_definition" "virtual_machine_user" {
  name = "Virtual Machine User Login"
}

// custom roles
// FIXME: the azurerm provider is buggy, so this cannot be created properly. Falling back to "Virtual Machine User Login"
// FIXME: which grants too many privileges. Needs to address this once https://github.com/terraform-providers/terraform-provider-azurerm/issues/10442
// FIXME: this is fixed
//resource "azurerm_role_definition" "vault_auth" {
//  name  = "${var.prefix}-vault-auth-role"
//  scope = data.azurerm_resource_group.this.id
//
//  assignable_scopes = [
//    data.azurerm_resource_group.this.id
//  ]
//
//  permissions {
//    actions = [
//      "Microsoft.Compute/virtualMachines/*/read",
//      "Microsoft.Compute/virtualMachineScaleSets/*/read",
//    ]
//  }
//}
