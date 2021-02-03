resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "ssh_key" {
  sensitive_content = chomp(tls_private_key.ssh_key.private_key_pem)
  filename          = "${path.module}/ssh-key"
  file_permission   = "0600"
}

resource "azurerm_network_interface" "control_plane" {
  count               = var.control_plane_instance_count
  name                = "${var.prefix}-control-plane-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_network_interface_application_security_group_association" "control_plane" {
  count                         = var.control_plane_instance_count
  application_security_group_id = azurerm_application_security_group.control_plane.id
  network_interface_id          = azurerm_network_interface.control_plane[count.index].id
}

resource "azurerm_linux_virtual_machine" "control_plane" {
  count = var.control_plane_instance_count

  admin_username = "centos"
  admin_ssh_key {
    public_key = tls_private_key.ssh_key.public_key_pem
    username   = "centos"
  }

  location              = var.location
  name                  = "${var.prefix}-control-plane-${count.index}"
  network_interface_ids = [azurerm_network_interface.control_plane[count.index].id]
  resource_group_name   = var.resource_group_name
  size                  = var.control_plane_size

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.control_plane_disk_size
  }

  source_image_reference { //todo
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.control_plane.id]
  }
  tags = var.tags
}

resource "azurerm_linux_virtual_machine_scale_set" "worker_plane" {
  admin_username = "centos"
  admin_ssh_key {
    public_key = tls_private_key.ssh_key.public_key_pem
    username   = "centos"
  }

  instances           = var.worker_plane_instance_count
  location            = var.location
  name                = "${var.prefix}-worker-plane"
  resource_group_name = var.resource_group_name
  sku                 = var.worker_plane_size

  network_interface {
    name = "${var.prefix}-worker-plane"
    ip_configuration {
      name      = "internal"
      subnet_id = azurerm_subnet.subnet.id
    }
  }

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.control_plane_disk_size
  }

  source_image_reference { //todo
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.worker_plane.id]
  }
  tags = var.tags
}