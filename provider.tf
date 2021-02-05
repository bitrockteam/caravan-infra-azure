provider "azurerm" {
  version = "~> 2.45.1"
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

//provider "azuread" {
//  version = "~> 1.3.0"
//}