#!/usr/bin/env bash
set -x

SUBSCRIPTION_ID=$1
PARENT_RESOURCE_GROUP=$2
LOCATION=$3
PREFIX=$4

RANDOM_STRING=$(openssl rand -hex 3)
RESOURCE_GROUP=${PREFIX}-rg
STORAGE_ACCOUNT=${PREFIX}${RANDOM_STRING}
CONTAINER_NAME=tfstate

az account set --subscription="$SUBSCRIPTION_ID"

OWNER=$(az account show | jq -r ".user.name")

echo "Creating resource group $RESOURCE_GROUP..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --tags "owner=$OWNER"

echo "Creating storage account..."
az storage account create --name "$STORAGE_ACCOUNT" --resource-group "$RESOURCE_GROUP" --location "$LOCATION" --tags "owner=$OWNER"

echo "Creating storage container..."
az storage container create --name "$CONTAINER_NAME" --resource-group "$RESOURCE_GROUP" --account-name "$STORAGE_ACCOUNT"

echo "Generating a service principal..."
SERVICE_PRINCIPAL=$(az ad sp create-for-rbac \
  --name="${PREFIX}-tf-sp" \
  --role="Contributor" \
  --scopes "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}" "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${PARENT_RESOURCE_GROUP}")

CLIENT_ID=$(echo "$SERVICE_PRINCIPAL" | jq -r ".appId")
CLIENT_SECRET=$(echo "$SERVICE_PRINCIPAL" | jq -r ".password")
TENANT_ID=$(echo "$SERVICE_PRINCIPAL" | jq -r ".tenant")

# Allow access for Terraform backend operations
az role assignment create \
  --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}" \
  --role "Storage Blob Data Contributor" \
  --assignee "$CLIENT_ID"

# Allow assigning permissions to other entities
az role assignment create \
  --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}" \
  --role "User Access Administrator" \
  --assignee "$CLIENT_ID"

cat <<EOT > backend.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "${RESOURCE_GROUP}"
    storage_account_name = "${STORAGE_ACCOUNT}"
    container_name       = "${CONTAINER_NAME}"
    key                  = "infraboot/terraform/state/terraform.tfstate"
    client_id            = "${CLIENT_ID}"
    client_secret        = "${CLIENT_SECRET}"
    tenant_id            = "${TENANT_ID}"
    subscription_id      = "${SUBSCRIPTION_ID}"
  }
}
EOT

cat <<EOT > azure.tfvars
resource_group_name        = "${RESOURCE_GROUP}"
image_resource_group_name  = "${PARENT_RESOURCE_GROUP}"
parent_resource_group_name = "${PARENT_RESOURCE_GROUP}"
storage_account_name       = "${STORAGE_ACCOUNT}"
prefix                     = "${PREFIX}"
location                   = "${LOCATION}"
external_domain            = "caravan-azure.bitrock.it"

client_id       = "${CLIENT_ID}"
client_secret   = "${CLIENT_SECRET}"
tenant_id       = "${TENANT_ID}"
subscription_id = "${SUBSCRIPTION_ID}"

tags = {
  project   = "caravan-${PREFIX}"
  managedBy = "terraform"
  repo      = "github.com/bitrockteam/caravan-infra-azure"
  owner     = "${OWNER}"
}

use_le_staging = true
EOT