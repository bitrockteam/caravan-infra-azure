#!/usr/bin/env bash

SUBSCRIPTION_ID=$1
RESOURCE_GROUP=$2
LOCATION=$3
NAME=$4

STORAGE_ACCOUNT=${NAME}sa
CONTAINER_NAME=tfstate

az account set --subscription="$SUBSCRIPTION_ID"

echo "Checking existence of resource group $RESOURCE_GROUP..."
if [ "$(az group list --query "[?name == '$RESOURCE_GROUP']" | jq "length")" = "0" ]; then
  echo "Creating resource group $RESOURCE_GROUP..."
  az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --tags caravan
fi

echo "Creating storage account..."
az storage account create --name "$STORAGE_ACCOUNT" --resource-group "$RESOURCE_GROUP" --location "$LOCATION" --tags caravan

echo "Creating storage container..."
az storage container create --name "$CONTAINER_NAME" --resource-group "$RESOURCE_GROUP" --account-name "$STORAGE_ACCOUNT"

cat <<EOT > backend.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "${RESOURCE_GROUP}"
    storage_account_name = "${STORAGE_ACCOUNT}"
    container_name       = "${CONTAINER_NAME}"
    key                  = "infraboot/terraform/state/terraform.tfstate"
  }
}
EOT

cat <<EOT > azure.tfvars
resource_group_name  = "${RESOURCE_GROUP}"
storage_account_name = "${STORAGE_ACCOUNT}"
prefix               = "${NAME}
location             = "${LOCATION}"
EOT