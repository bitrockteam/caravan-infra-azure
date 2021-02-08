resource "azurerm_key_vault" "key_vault" {
  location               = var.location
  name                   = "${var.prefix}-keyvault"
  resource_group_name    = var.resource_group_name
  sku_name               = "standard"
  tenant_id              = data.azurerm_client_config.this.tenant_id
  tags                   = var.tags
  enabled_for_deployment = true

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_access_policy" "self" {
  key_vault_id = azurerm_key_vault.key_vault.id
  object_id    = data.azurerm_client_config.this.object_id
  tenant_id    = var.tenant_id

  key_permissions = [
    "backup",
    "create",
    "delete",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "update"
  ]
}

resource "azurerm_key_vault_access_policy" "control_plane" {
  key_vault_id = azurerm_key_vault.key_vault.id
  object_id    = azurerm_user_assigned_identity.control_plane.principal_id
  tenant_id    = data.azurerm_client_config.this.tenant_id

  key_permissions = [
    "get",
    "wrapKey",
    "unwrapKey",
  ]
}

resource "azurerm_key_vault_key" "key" {
  depends_on = [azurerm_key_vault_access_policy.self]

  name         = "${var.prefix}-vault-unseal-key"
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "wrapKey",
    "unwrapKey",
  ]

  tags = var.tags
}