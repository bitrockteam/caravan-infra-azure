data "azurerm_dns_zone" "parent" {
  name                = var.external_domain
  resource_group_name = var.parent_resource_group_name
}

resource "azurerm_dns_zone" "this" {
  name                = "${var.prefix}.${var.external_domain}"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_dns_ns_record" "this" {
  name                = var.prefix
  records             = azurerm_dns_zone.this.name_servers
  resource_group_name = var.parent_resource_group_name
  ttl                 = 30
  zone_name           = data.azurerm_dns_zone.parent.name

  tags = var.tags
}

resource "azurerm_dns_a_record" "star" {
  name                = "*"
  records             = [azurerm_public_ip.lb.ip_address]
  resource_group_name = var.resource_group_name
  ttl                 = 30
  zone_name           = azurerm_dns_zone.this.name

  tags = var.tags
}

resource "azurerm_dns_a_record" "control_plane_internal" {
  for_each = local.ag_control_plane_apps

  name                = "${each.key}-internal"
  records             = [local.ag_private_ip]
  resource_group_name = var.resource_group_name
  ttl                 = 30
  zone_name           = azurerm_dns_zone.this.name

  tags = var.tags
}