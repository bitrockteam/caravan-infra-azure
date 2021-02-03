resource "azurerm_virtual_network" "vnet" {
  address_space       = var.vnet_cidrs
  location            = var.location
  name                = "${var.prefix}-vnet"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_subnet" "app_gateway" {
  name                 = "${var.prefix}-app-gateway-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.app_gateway_subnet_cidr]
}

resource "azurerm_subnet_network_security_group_association" "default" {
  network_security_group_id = azurerm_network_security_group.default.id
  subnet_id                 = azurerm_subnet.subnet.id
}
