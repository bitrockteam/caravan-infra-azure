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
  value = [for n in azurerm_linux_virtual_machine.control_plane : n.identity[0].principal_id]
}

output "worker_plane_service_principal_ids" {
  value = concat(
    [for n in azurerm_linux_virtual_machine_scale_set.worker_plane.identity : n.principal_id],
    [for n in azurerm_linux_virtual_machine.monitoring : n.identity[0].principal_id]
  )
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
