resource "azurerm_managed_disk" "csi" {
  for_each = var.csi_volumes

  create_option        = "Empty"
  location             = var.location
  name                 = each.key
  resource_group_name  = var.resource_group_name
  storage_account_type = lookup(each.value, "storage_account_type", "Standard_LRS")
  disk_size_gb         = lookup(each.value, "disk_size_gb", 30)
  tags                 = var.tags
}

locals {
  volumes_name_to_id = { for v in azurerm_managed_disk.csi : v.name => v.id }
}
