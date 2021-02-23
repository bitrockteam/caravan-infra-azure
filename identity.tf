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
  role_definition_id = data.azurerm_role_definition.owner.id
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

data "azurerm_role_definition" "owner" {
  name  = "Owner"
  scope = data.azurerm_subscription.this.id
}

data "azurerm_role_definition" "key_vault_user" {
  name  = "Key Vault Crypto User"
  scope = data.azurerm_resource_group.this.id
}

### Vault Azure Secrets Engine
resource "azuread_application" "vault" {
  display_name = "${var.prefix}-vault"
  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"
    resource_access {
      id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6" // User.Read
      type = "Scope"
    }
    resource_access {
      id   = "1cda74f2-2616-4834-b122-5cb1b07f8a59" // Application.ReadWrite.All
      type = "Role"
    }
    resource_access {
      id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175" // Directory.ReadWrite.All
      type = "Role"
    }
  }
  app_role {
    allowed_member_types = [
      "User",
      "Application",
    ]
    description  = "Admins can manage roles and perform all task actions"
    display_name = "Admin"
    is_enabled   = true
    value        = "Admin"
  }
  oauth2_permissions {
    admin_consent_description  = "Administer the example application"
    admin_consent_display_name = "Administer"
    is_enabled                 = true
    type                       = "Admin"
    value                      = "administer"
  }
  owners = [
    data.azurerm_client_config.this.object_id,
    data.azuread_client_config.this.object_id
  ]
}
resource "azuread_application_password" "vault" {
  application_object_id = azuread_application.vault.object_id
  value                 = random_string.vault_password.result
  end_date_relative     = "17520h"
}
resource "azuread_service_principal" "vault" {
  application_id = azuread_application.vault.application_id
}
resource "azurerm_role_assignment" "vault" {
  principal_id       = azuread_service_principal.vault.object_id
  role_definition_id = data.azurerm_role_definition.owner.id
  scope              = data.azurerm_subscription.this.id
}
resource "random_string" "vault_password" {
  length = 32
}
