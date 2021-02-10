resource "azuread_application" "vault" {
  name = "${var.prefix}-vault"
  identifier_uris = [
    "https://${var.prefix}-vault.azure.com"
  ]
  owners = concat(
    [data.azurerm_client_config.this.object_id],
    azurerm_linux_virtual_machine.control_plane.*.identity.principal_id
  )
  available_to_other_tenants = false
}
