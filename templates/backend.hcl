
terraform {
  backend "azurerm" {
    resource_group_name  = "${resource_group_name}"
    storage_account_name = "${storage_account_name}"
    container_name       = "tfstate"
    key                  = "${key}/terraform/state/terraform.tfstate"
    client_id            = "${client_id}"
    client_secret        = "${client_secret}"
    tenant_id            = "${tenant_id}"
    subscription_id      = "${subscription_id}"
  }
}
