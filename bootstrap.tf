module "caravan_bootstrap" {
  source = "git::https://github.com/bitrockteam/caravan-bootstrap?ref=refs/tags/v0.2.13"

  ssh_private_key                = chomp(tls_private_key.ssh_key.private_key_pem)
  ssh_user                       = "centos"
  ssh_timeout                    = "240s"
  control_plane_nodes_ids        = [for n in azurerm_linux_virtual_machine.control_plane : n.virtual_machine_id]
  control_plane_nodes            = { for n in azurerm_linux_virtual_machine.control_plane : n.name => n.private_ip_address }
  control_plane_nodes_public_ips = { for n in azurerm_linux_virtual_machine.control_plane : n.name => n.public_ip_address }
  tcp_listener_tls               = false
  dc_name                        = var.dc_name
  prefix                         = var.prefix
  vault_endpoint                 = "http://127.0.0.1:8200"
  control_plane_role_name        = local.control_plane_role_name
  external_domain                = var.external_domain

  unseal_type          = "azure"
  agent_auto_auth_type = "azure"

  azure_tenant_id  = data.azurerm_client_config.this.tenant_id
  azure_vault_name = azurerm_key_vault.key_vault.name
  azure_key_name   = azurerm_key_vault_key.key.name
  azure_resource   = var.vault_auth_resource
  azure_node_role  = local.control_plane_role_name

  consul_license = var.consul_license_file != null ? file(var.consul_license_file) : ""
  vault_license  = var.vault_license_file != null ? file(var.vault_license_file) : ""
  nomad_license  = var.nomad_license_file != null ? file(var.nomad_license_file) : ""

  depends_on = [
    azurerm_linux_virtual_machine.control_plane,
    azurerm_network_interface.control_plane,
    azurerm_network_interface_application_security_group_association.control_plane,
    azurerm_network_security_group.default,
    azurerm_key_vault_access_policy.control_plane,
    azurerm_key_vault_key.key,
    azurerm_virtual_machine_data_disk_attachment.vault_data,
    azurerm_virtual_machine_data_disk_attachment.consul_data,
    azurerm_virtual_machine_data_disk_attachment.nomad_data
  ]
}
