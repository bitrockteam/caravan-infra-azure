#!/usr/bin/env bash

SUBSCRIPTION_ID=$1
RESOURCE_GROUP=$2
LOCATION=$3
NAME=$4

STORAGE_ACCOUNT=$NAME-terraform-states
CONTAINER_NAME=tfstate

az account set --subscription="$SUBSCRIPTION_ID"

echo "Deleting storage container..."
az storage container delete --name "$CONTAINER_NAME" --account-name "$STORAGE_ACCOUNT"

echo "Deleting storage account..."
az storage account delete --name "$STORAGE_ACCOUNT" --resource-group "$RESOURCE_GROUP"

echo "Deleting resource group $RESOURCE_GROUP..."
az group delete --name "$RESOURCE_GROUP"
