#!/usr/bin/env bash
set -x

SUBSCRIPTION_ID=$1
PREFIX=$2

RESOURCE_GROUP=${PREFIX}-rg
SP_NAME=$PREFIX-tf-sp

az account set --subscription="$SUBSCRIPTION_ID"

echo "Deleting resource group $RESOURCE_GROUP..."
az group delete --name "$RESOURCE_GROUP"

echo "Deleting service principal ${SP_NAME}"
SP_ID=$(az ad sp list --all --query "[?displayName=='$SP_NAME'].appId" | jq -r '.[]')
az ad sp delete --id "${SP_ID}"
