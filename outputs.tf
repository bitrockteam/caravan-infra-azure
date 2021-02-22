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
  value = [azurerm_user_assigned_identity.control_plane.principal_id]
}

output "worker_plane_service_principal_ids" {
  value = [azurerm_user_assigned_identity.worker_plane.principal_id]
}

output "resource_group_name" {
  value = data.azurerm_resource_group.this.name
}

output "subscription_id" {
  value = var.subscription_id
}

output "vault_resource_name" {
  value = var.vault_auth_resource
}

output "platform_tfvars" {
  value = local.tfvars_platform
}

output "platform_backend" {
  value = local.backend_tf_platform
}

output "appsupport_tfvars" {
  value = local.tfvars_appsupport
}

output "appsupport_backend" {
  value = local.backend_tf_appsupport
}

output "workload_tfvars" {
  value = local.tfvars_workload
}

output "workload_backend" {
  value = local.backend_tf_workload
}

output "ips" {
  value = {
    control_plane = { for n in azurerm_linux_virtual_machine.control_plane : n.name => n.public_ip_address }
    monitoring    = { for n in azurerm_linux_virtual_machine.monitoring : n.name => n.public_ip_address }
  }
}

output "csi_volumes" {
  value = local.volumes_name_to_id
}

output "vault_client_id" {
  value = azuread_application.vault.application_id
}

output "vault_client_secret" {
  value = azuread_application_password.vault.value
}

output "zzz_vault_ad_app" {
  value = <<EOT
In order to complete the setup of Vault AD Application permissions, you need to run as a Global administrator:
`az ad app permission grant --id "${azuread_application.vault.application_id}" --api 00000002-0000-0000-c000-000000000000`
or open `https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/CallAnAPI/appId/${azuread_application.vault.application_id}/isMSAApp/` and grant admin consent
EOT
}
