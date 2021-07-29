locals {
  le_staging    = "https://acme-staging-v02.api.letsencrypt.org/directory"
  le_production = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "acme" {
  server_url = var.use_le_staging ? local.le_staging : local.le_production
}

module "terraform_acme_le" {
  depends_on            = [azurerm_dns_ns_record.this]
  source                = "git::https://github.com/bitrockteam/caravan-acme-le?ref=refs/tags/v0.0.11"
  common_name           = "${var.prefix}.${var.external_domain}"
  dns_provider          = "azure"
  private_key           = tls_private_key.cert_private_key.private_key_pem
  azure_subscription_id = var.subscription_id
  azure_tenant_id       = data.azurerm_client_config.this.tenant_id
  azure_resource_group  = var.resource_group_name
  azure_client_id       = var.client_id
  azure_client_secret   = var.client_secret
  azure_environment     = "public"
  from_csr              = false
}

resource "tls_private_key" "cert_private_key" {
  algorithm = "RSA"
}

resource "null_resource" "ca_certs" {
  for_each = var.ca_certs
  provisioner "local-exec" {
    command = "curl -o ${each.value.filename} ${each.value.pemurl}"
  }
}

resource "null_resource" "ca_certs_bundle" {
  depends_on = [
    null_resource.ca_certs
  ]
  count = length(var.ca_certs)
  provisioner "local-exec" {
    command = "cat ${join(" ", [for k, v in var.ca_certs : v.filename])} > ca_certs.pem"
  }
}
