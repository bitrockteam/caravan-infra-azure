// network
resource "azurerm_network_security_group" "default" {
  location            = var.location
  name                = "${var.prefix}-default-sg"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "allow_in_ssh" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "${var.prefix}-allow-in-ssh"
  network_security_group_name = azurerm_network_security_group.default.name
  priority                    = 500
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_port_range           = "*"
  source_address_prefixes     = var.allowed_ssh_cidrs
  destination_port_range      = "22"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "allow_in_icmp" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "${var.prefix}-allow-in-icmp"
  network_security_group_name = azurerm_network_security_group.default.name
  priority                    = 501
  protocol                    = "Icmp"
  source_address_prefixes     = var.allowed_ssh_cidrs
  source_port_range           = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
}


// application - control plane
resource "azurerm_application_security_group" "control_plane" {
  location            = var.location
  name                = "${var.prefix}-control-plane-sg"
  resource_group_name = var.resource_group_name
}


// application - worker plane
resource "azurerm_application_security_group" "worker_plane" {
  location            = var.location
  name                = "${var.prefix}-worker-plane-sg"
  resource_group_name = var.resource_group_name
}

