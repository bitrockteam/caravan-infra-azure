data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_client_config" "this" {}

data "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_image" "caravan" {
  resource_group_name = var.image_resource_group_name
  name_regex          = var.image_name_regex
  sort_descending     = true
}

data "azurerm_subscription" "this" {}