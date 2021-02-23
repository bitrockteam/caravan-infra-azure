resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "local_file" "ssh_key" {
  sensitive_content = chomp(tls_private_key.ssh_key.private_key_pem)
  filename          = "${path.module}/ssh-key"
  file_permission   = "0600"
}

locals {
  main_ip_config = "internal"
}

resource "azurerm_public_ip" "control_plane" {
  count               = var.control_plane_instance_count
  name                = "${var.prefix}-control-plane-ip-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = var.tags
}

resource "azurerm_network_interface" "control_plane" {
  count               = var.control_plane_instance_count
  name                = "${var.prefix}-control-plane-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = local.main_ip_config
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.control_plane[count.index].id
  }

  tags = var.tags
}

resource "azurerm_public_ip" "monitoring" {
  count = var.enable_monitoring ? 1 : 0

  name                = "${var.prefix}-monitoring-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = var.tags
}

resource "azurerm_network_interface" "monitoring" {
  count = var.enable_monitoring ? 1 : 0

  name                = "${var.prefix}-monitoring"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = local.main_ip_config
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.monitoring[count.index].id
  }

  tags = var.tags
}

resource "azurerm_network_interface_application_security_group_association" "control_plane" {
  count                         = var.control_plane_instance_count
  application_security_group_id = azurerm_application_security_group.control_plane.id
  network_interface_id          = azurerm_network_interface.control_plane[count.index].id
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "control_plane" {
  depends_on = [azurerm_application_gateway.this]
  count      = var.control_plane_instance_count

  backend_address_pool_id = azurerm_application_gateway.this.backend_address_pool[0].id
  ip_configuration_name   = local.main_ip_config
  network_interface_id    = azurerm_network_interface.control_plane[count.index].id
}

resource "azurerm_network_interface_application_security_group_association" "monitoring" {
  count                         = var.enable_monitoring ? 1 : 0
  application_security_group_id = azurerm_application_security_group.worker_plane.id
  network_interface_id          = azurerm_network_interface.monitoring[count.index].id
}

resource "azurerm_network_interface_application_security_group_association" "monitoring_2" {
  count                         = var.enable_monitoring ? 1 : 0
  application_security_group_id = azurerm_application_security_group.monitoring.id
  network_interface_id          = azurerm_network_interface.monitoring[count.index].id
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "monitoring" {
  depends_on = [azurerm_application_gateway.this]
  count      = var.enable_monitoring ? 1 : 0

  backend_address_pool_id = azurerm_application_gateway.this.backend_address_pool[1].id
  ip_configuration_name   = local.main_ip_config
  network_interface_id    = azurerm_network_interface.monitoring[count.index].id
}

resource "azurerm_linux_virtual_machine" "control_plane" {
  count = var.control_plane_instance_count

  admin_username = "centos"
  admin_ssh_key {
    public_key = tls_private_key.ssh_key.public_key_openssh
    username   = "centos"
  }

  location              = var.location
  name                  = "${var.prefix}-control-plane-${count.index}"
  network_interface_ids = [azurerm_network_interface.control_plane[count.index].id]
  resource_group_name   = var.resource_group_name
  size                  = var.control_plane_size
  custom_data           = module.cloud_init_control_plane.control_plane_user_data

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.control_plane_disk_size
  }

  source_image_id = data.azurerm_image.caravan.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.control_plane.id]
  }
  tags = var.tags
}

resource "azurerm_linux_virtual_machine_scale_set" "worker_plane" {
  depends_on = [azurerm_application_gateway.this]

  admin_username = "centos"
  admin_ssh_key {
    public_key = tls_private_key.ssh_key.public_key_openssh
    username   = "centos"
  }

  instances           = var.worker_plane_instance_count
  location            = var.location
  name                = "${var.prefix}-worker-plane"
  resource_group_name = var.resource_group_name
  sku                 = var.worker_plane_size
  custom_data         = module.cloud_init_worker_plane.worker_plane_user_data

  network_interface {
    name    = "${var.prefix}-worker-plane"
    primary = true
    ip_configuration {
      name                                         = local.main_ip_config
      subnet_id                                    = azurerm_subnet.subnet.id
      application_security_group_ids               = [azurerm_application_security_group.worker_plane.id]
      application_gateway_backend_address_pool_ids = [azurerm_application_gateway.this.backend_address_pool[1].id]
      primary                                      = true
      public_ip_address {
        name = "${var.prefix}-worker-plane-public-ip"
      }
    }
  }

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.worker_plane_disk_size
  }

  source_image_id = data.azurerm_image.caravan.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.worker_plane.id]
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "monitoring" {
  depends_on = [azurerm_application_gateway.this]
  count      = var.enable_monitoring ? 1 : 0

  admin_username = "centos"
  admin_ssh_key {
    public_key = tls_private_key.ssh_key.public_key_openssh
    username   = "centos"
  }

  location              = var.location
  name                  = "${var.prefix}-monitoring"
  network_interface_ids = [azurerm_network_interface.monitoring[count.index].id]
  resource_group_name   = var.resource_group_name
  size                  = var.monitoring_size
  custom_data           = module.cloud_init_worker_plane.monitoring_user_data

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.monitoring_disk_size
  }

  source_image_id = data.azurerm_image.caravan.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.worker_plane.id]
  }
  tags = var.tags
}
