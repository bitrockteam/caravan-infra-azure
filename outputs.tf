output "control_plane_role_name" {
  value = local.control_plane_role_name
}

output "worker_plane_role_name" {
  value = local.worker_plane_role_name
}

output "tenant_id" {
  value = data.azurerm_client_config.this.tenant_id
}

output "control_plane_service_principal_ids" {
  value = [for n in azurerm_linux_virtual_machine.control_plane : n.identity[0].principal_id ]
}

output "worker_plane_service_principal_ids" {
  value = [for n in azurerm_linux_virtual_machine_scale_set.worker_plane.identity: n.principal_id ]
}

output "resource_group_name" {
  value = data.azurerm_resource_group.this.name
}

output "subscription_id" {
  value = data.azurerm_subscription.this.id
}

output "resource_name" {
  value = azuread_application.vault.identifier_uris
}
