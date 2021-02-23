provider "azurerm" {
  version = "~> 2.46.1"
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
/*
// This requires running `az ad app permission grant --id "${var.client_id}" --api 00000002-0000-0000-c000-000000000000`
// as an Azure AD administrator or opening `https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/CallAnAPI/appId/${var.client_id}/isMSAApp/`
// When provider is omitted, the default from CLI is used

provider "azuread" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
*/
