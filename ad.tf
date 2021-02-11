resource "azuread_application" "vault" {
  name = "${var.prefix}-vault"
  identifier_uris = [
    "https://${var.prefix}-vault.azure.com"
  ]
  owners = concat(
    [data.azurerm_client_config.this.object_id],
    [ for n in azurerm_linux_virtual_machine.control_plane : n.identity[0].principal_id ]
  )
  available_to_other_tenants = false
}

resource "random_string" "password" {
  length  = 32
  special = false
}

resource "azuread_application_password" "vault" {
  value = random_string.password.result
  application_object_id = azuread_application.vault.object_id
  end_date_relative = "17520h"
}
