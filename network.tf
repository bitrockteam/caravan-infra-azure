resource "azurerm_virtual_network" "vnet" {
  address_space = var.vnet_cidrs
  location = var.location
  name = "${var.prefix}-vnet"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet" "subnet" {
  name = "${var.prefix}-subnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.subnet_cidr]
}

resource "azurerm_subnet_network_security_group_association" "default" {
  network_security_group_id = azurerm_network_security_group.default.id
  subnet_id = azurerm_subnet.subnet.id
}

resource "azurerm_network_security_group" "default" {
  location = var.location
  name = "${var.prefix}-default-sg"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "allow_in_ssh" {
  access = "Allow"
  direction = "Inbound"
  name = "${var.prefix}-allow-in-ssh"
  network_security_group_name = azurerm_network_security_group.default.name
  priority = 500
  protocol = "Tcp"
  resource_group_name = var.resource_group_name
  source_port_range = "*"
  source_address_prefixes = var.allowed_ssh_cidrs
  destination_port_range = "22"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "allow_in_icmp" {
  access = "Allow"
  direction = "Inbound"
  name = "${var.prefix}-allow-in-icmp"
  network_security_group_name = azurerm_network_security_group.default.name
  priority = 501
  protocol = "Icmp"
  source_address_prefixes = var.allowed_ssh_cidrs
  source_port_range = "*"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = var.resource_group_name
}
