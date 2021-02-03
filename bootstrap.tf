module "hashicorp-bootstrap" {
  source                         = "git::ssh://git@github.com/bitrockteam/hashicorp-terraform-bootstrap?ref=main"
  ssh_private_key                = chomp(tls_private_key.ssh_key.private_key_pem)
  ssh_user                       = "centos"
  ssh_timeout                    = "240s"
  control_plane_nodes_ids        = [for n in azurerm_linux_virtual_machine.control_plane : n.name]
  control_plane_nodes            = { for n in azurerm_linux_virtual_machine.control_plane : n.name => n.private_ip_address }
  control_plane_nodes_public_ips = { for n in azurerm_linux_virtual_machine.control_plane : n.name => n.public_ip_address }
  tcp_listener_tls               = false
  dc_name                        = var.dc_name
  prefix                         = var.prefix
  vault_endpoint                 = "http://127.0.0.1:8200"
  control_plane_role_name        = local.control_plane_role_name

  unseal_type          = "azure"
  agent_auto_auth_type = "azure"

  //TODO azure_...
  azure_tenant_id  = data.azurerm_client_config.this.tenant_id
  azure_vault_name = azurerm_key_vault.key_vault.name
  azure_key_name   = azurerm_key_vault_key.key.name
}
