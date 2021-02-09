// network
resource "azurerm_network_security_group" "default" {
  location            = var.location
  name                = "${var.prefix}-default-sg"
  resource_group_name = var.resource_group_name

  tags = var.tags
}
resource "azurerm_network_security_group" "app_gateway" {
  location            = var.location
  name                = "${var.prefix}-app-gateway-sg"
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

resource "azurerm_network_security_rule" "allow_in_internal" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "${var.prefix}-allow-in-control-plane-from-control-plane"
  network_security_group_name = azurerm_network_security_group.default.name
  priority                    = 502
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  source_application_security_group_ids = [
    azurerm_application_security_group.control_plane.id
  ]
  source_port_range = "*"
  destination_application_security_group_ids = [
    azurerm_application_security_group.control_plane.id
  ]
  destination_port_ranges = [
    8200,
    8201,
    8300,
    8301,
    8302,
    8500,
    8501,
    8502,
    4646,
    4647,
    4648
  ]
}

resource "azurerm_network_security_rule" "allow_in_internal_2" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "${var.prefix}-allow-in-control-plane-from-worker-plane"
  network_security_group_name = azurerm_network_security_group.default.name
  priority                    = 503
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  source_application_security_group_ids = [
    azurerm_application_security_group.worker_plane.id
  ]
  source_port_range = "*"
  destination_application_security_group_ids = [
    azurerm_application_security_group.control_plane.id
  ]
  destination_port_ranges = [
    8200,
    8201,
    8300,
    8301,
    8302,
    8500,
    8501,
    8502,
    4646,
    4647,
    4648
  ]
}

resource "azurerm_network_security_rule" "allow_in_lb" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "${var.prefix}-allow-in-from-lb"
  network_security_group_name = azurerm_network_security_group.default.name
  priority                    = 504
  protocol                    = "tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "AzureLoadBalancer"
  source_port_range           = "*"
  destination_application_security_group_ids = [
    azurerm_application_security_group.control_plane.id
  ]
  destination_port_ranges = [
    8080,
    8200,
    8500,
    4646
  ]
}

resource "azurerm_network_security_rule" "lb_default_rules" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "${var.prefix}-allow-in-internet-to-loadbalancer"
  network_security_group_name = azurerm_network_security_group.app_gateway.name
  priority                    = 505
  protocol                    = "tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "GatewayManager"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "65200-65535"
}

// application - control plane
resource "azurerm_application_security_group" "control_plane" {
  location            = var.location
  name                = "${var.prefix}-control-plane-sg"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

// application - worker plane
resource "azurerm_application_security_group" "worker_plane" {
  location            = var.location
  name                = "${var.prefix}-worker-plane-sg"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

