locals {
  control_plane_role_name = "control-plane"
  worker_plane_role_name  = "worker-plane"
}

module "cloud_init_control_plane" {
  source          = "git::https://github.com/bitrockteam/caravan-cloudinit?ref=refs/tags/v0.1.4"
  cluster_nodes   = { for n in azurerm_linux_virtual_machine.control_plane : n.name => n.private_ip_address }
  vault_endpoint  = "http://127.0.0.1:8200"
  dc_name         = var.dc_name
  auto_auth_type  = "azure"
  azure_node_role = local.control_plane_role_name
  azure_resource  = var.vault_auth_resource
}

module "cloud_init_worker_plane" {
  source          = "git::https://github.com/bitrockteam/caravan-cloudinit?ref=refs/tags/v0.1.4"
  cluster_nodes   = { for n in azurerm_linux_virtual_machine.control_plane : n.name => n.private_ip_address }
  vault_endpoint  = "http://vault-internal.${var.prefix}.${var.external_domain}:8080"
  dc_name         = var.dc_name
  auto_auth_type  = "azure"
  azure_node_role = local.worker_plane_role_name
  azure_resource  = var.vault_auth_resource
}
