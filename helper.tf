locals {
  tfvars_platform = templatefile("${path.module}/templates/platform.tfvars.hcl", {
    prefix               = var.prefix
    external_domain      = var.external_domain
    use_le_staging       = var.use_le_staging
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    client_id            = var.client_id
    client_secret        = var.client_secret
    tenant_id            = var.tenant_id
    subscription_id      = var.subscription_id
  })
  backend_tf_platform = templatefile("${path.module}/templates/backend.hcl", {
    key                  = "platform"
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    client_id            = var.client_id
    client_secret        = var.client_secret
    tenant_id            = var.tenant_id
    subscription_id      = var.subscription_id
  })

  tfvars_appsupport = templatefile("${path.module}/templates/appsupport.tfvars.hcl", {
    prefix            = var.prefix
    external_domain   = var.external_domain
    use_le_staging    = var.use_le_staging
    dc_name           = var.dc_name
    jenkins_volume_id = lookup(local.volumes_name_to_id, "jenkins", "")
    tenant_id         = var.tenant_id
    subscription_id   = var.subscription_id
  })
  backend_tf_appsupport = templatefile("${path.module}/templates/backend.hcl", {
    key                  = "appsupport"
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    client_id            = var.client_id
    client_secret        = var.client_secret
    tenant_id            = var.tenant_id
    subscription_id      = var.subscription_id
  })

  tfvars_workload = templatefile("${path.module}/templates/workload.tfvars.hcl", {
    prefix          = var.prefix
    external_domain = var.external_domain
    use_le_staging  = var.use_le_staging
    dc_name         = var.dc_name
  })
  backend_tf_workload = templatefile("${path.module}/templates/backend.hcl", {
    key                  = "workload"
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    client_id            = var.client_id
    client_secret        = var.client_secret
    tenant_id            = var.tenant_id
    subscription_id      = var.subscription_id
  })
}

resource "local_file" "tfvars_platform" {
  filename = "${path.module}/../caravan-platform/${var.prefix}-azure.tfvars"
  content  = local.tfvars_platform
}
resource "local_file" "backend_tf_platform" {
  filename = "${path.module}/../caravan-platform/${var.prefix}-azure-backend.tf.bak"
  content  = local.backend_tf_platform
}

resource "local_file" "tfvars_appsupport" {
  filename = "${path.module}/../caravan-application-support/${var.prefix}-azure.tfvars"
  content  = local.tfvars_appsupport
}
resource "local_file" "backend_tf_appsupport" {
  filename = "${path.module}/../caravan-application-support/${var.prefix}-azure-backend.tf.bak"
  content  = local.backend_tf_appsupport
}

resource "local_file" "tfvars_workload" {
  filename = "${path.module}/../caravan-workload/${var.prefix}-azure.tfvars"
  content  = local.tfvars_workload
}
resource "local_file" "backend_tf_workload" {
  filename = "${path.module}/../caravan-workload/${var.prefix}-azure-backend.tf.bak"
  content  = local.backend_tf_workload
}
