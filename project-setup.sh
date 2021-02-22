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
CLOUD_NAME=azure

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

# Grant Application.ReadWrite.All
az ad app permission add --id "${CLIENT_ID}" --api 00000002-0000-0000-c000-000000000000 --api-permissions 1cda74f2-2616-4834-b122-5cb1b07f8a59=Role
# Grant User.Read
az ad app permission add --id "${CLIENT_ID}" --api 00000002-0000-0000-c000-000000000000 --api-permissions 311a71cc-e848-46a1-bdf8-97ff7156d8e6=Scope
# Grant Directory.ReadWrite.All
az ad app permission add --id "${CLIENT_ID}" --api 00000002-0000-0000-c000-000000000000 --api-permissions 78c8a3c8-a07e-4b9e-af1b-b5ccab50a175=Role
# Apply changes
az ad app permission grant --id "${CLIENT_ID}" --api 00000002-0000-0000-c000-000000000000

# Allow access for Terraform backend operations
az role assignment create \
  --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}" \
  --role "Storage Blob Data Contributor" \
  --assignee "$CLIENT_ID"

# Allow assigning permissions to other entities
az role assignment create \
  --scope "/subscriptions/${SUBSCRIPTION_ID}" \
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

cat <<EOT > run.sh
#!/usr/bin/env bash
set -e

EXTERNAL_DOMAIN="example.com" # replace
export VAULT_ADDR="https://vault.${PREFIX}.\${EXTERNAL_DOMAIN}"
export CONSUL_ADDR="https://consul.${PREFIX}.\${EXTERNAL_DOMAIN}"
export NOMAD_ADDR="https://nomad.${PREFIX}.\${EXTERNAL_DOMAIN}"

DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Deploying infrastructure..."

terraform init -reconfigure -upgrade
terraform apply -var-file ${CLOUD_NAME}.tfvars -auto-approve

export VAULT_TOKEN=\$(cat ".${PREFIX}-root_token")
export NOMAD_TOKEN=\$(vault read -tls-skip-verify -format=json nomad/creds/token-manager | jq -r .data.secret_id)

echo "Waiting for Vault \${VAULT_ADDR} to be up..."
while [ \$(curl -k --silent --output /dev/null --write-out "%{http_code}" "\${VAULT_ADDR}/v1/sys/leader") != "200" ]; do
  echo "Waiting for Vault to be up..."
  sleep 5
done

echo "Waiting for Consul \${CONSUL_ADDR} to be up..."
while [ \$(curl -k --silent --output /dev/null --write-out "%{http_code}" "\${CONSUL_ADDR}/v1/status/leader") != "200" ]; do
  echo "Waiting for Consul to be up..."
  sleep 5
done

echo "Waiting for Nomad \${NOMAD_ADDR} to be up..."
while [ \$(curl -k --silent --output /dev/null --write-out "%{http_code}" "\${NOMAD_ADDR}/v1/status/leader") != "200" ]; do
  echo "Waiting for Nomad to be up..."
  sleep 5
done

echo "Configuring platform..."

cd "\$DIR/../caravan-platform"
cp "${PREFIX}-${CLOUD_NAME}-backend.tf.bak" "backend.tf"

terraform init -reconfigure -upgrade
terraform apply -var-file "${PREFIX}-${CLOUD_NAME}.tfvars" -auto-approve

echo "Waiting for Consul Connect to be ready..."
while [ \$(curl -k --silent --output /dev/null --write-out "%{http_code}" "\${CONSUL_ADDR}/v1/connect/ca/roots") != "200" ]; do
  echo "Waiting for Consul Connect to be ready..."
  sleep 5
done

echo "Configuring application support..."

cd "\$DIR/../caravan-application-support"
cp "${PREFIX}-${CLOUD_NAME}-backend.tf.bak" "backend.tf"

terraform init -reconfigure -upgrade
terraform apply -var-file "${PREFIX}-${CLOUD_NAME}.tfvars" -auto-approve

echo "Configuring sample workload..."

cd "\$DIR/../caravan-workload"
cp "${PREFIX}-${CLOUD_NAME}-backend.tf.bak" "backend.tf"

terraform init -reconfigure -upgrade
terraform apply -var-file "${PREFIX}-${CLOUD_NAME}.tfvars" -auto-approve

cd "\$DIR"

echo "Done."
EOT

cat <<EOT > destroy.sh
#!/usr/bin/env bash
set -e

EXTERNAL_DOMAIN="example.com" # replace
export VAULT_ADDR="https://vault.${PREFIX}.\${EXTERNAL_DOMAIN}"
export CONSUL_ADDR="https://consul.${PREFIX}.\${EXTERNAL_DOMAIN}"
export NOMAD_ADDR="https://nomad.${PREFIX}.\${EXTERNAL_DOMAIN}"

DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export VAULT_TOKEN=\$(cat ".${PREFIX}-root_token")
export NOMAD_TOKEN=\$(vault read -tls-skip-verify -format=json nomad/creds/token-manager | jq -r .data.secret_id)

echo "Destroying sample workload..."

cd "\$DIR/../caravan-workload"
cp "${PREFIX}-${CLOUD_NAME}-backend.tf.bak" "backend.tf"

terraform init -reconfigure -upgrade
terraform destroy -var-file "${PREFIX}-${CLOUD_NAME}.tfvars" -auto-approve

echo "Destroying application support..."

cd "\$DIR/../caravan-application-support"
cp "${PREFIX}-${CLOUD_NAME}-backend.tf.bak" "backend.tf"

terraform init -reconfigure -upgrade
terraform destroy -var-file "${PREFIX}-${CLOUD_NAME}.tfvars" -auto-approve

echo "Destroying platform..."

cd "\$DIR/../caravan-platform"
cp "${PREFIX}-${CLOUD_NAME}-backend.tf.bak" "backend.tf"

terraform init -reconfigure -upgrade
terraform destroy -var-file "${PREFIX}-${CLOUD_NAME}.tfvars" -auto-approve

echo "Destroying infrastructure..."

cd "\$DIR"

terraform init -reconfigure -upgrade
terraform destroy -var-file ${CLOUD_NAME}.tfvars -auto-approve

echo "Done."
EOT

chmod +x run.sh
chmod +x destroy.sh

echo "All set, review configs and execute 'run.sh' and 'destroy.sh'. Enjoy!."
