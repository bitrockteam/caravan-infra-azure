resource "azurerm_managed_disk" "jenkins" {
  count = var.azure_csi ? 1 : 0

  create_option        = "Empty"
  location             = var.location
  name                 = "${var.prefix}-jenkins"
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 30
  storage_account_id   = data.azurerm_storage_account.this.id

  tags = var.tags
}
