# Caravan Infra Azure

![Caravan 2021 Azure](https://lucid.app/publicSegments/view/8e3cc368-8aa8-4f42-b96e-f7b529442c94/image.png)

## Setup

```shell
# SUBSCRIPTION_ID where to create resources
# PARENT_RESOURCE_GROUP that contains VM images and shared DNS
# LOCAITON where to create resources
# PREFIX prepended to all resources name 
./project-setup.sh SUBSCRIPTION_ID PARENT_RESOURCE_GROUP LOCATION PREFIX
```

## Teardown
```shell
# SUBSCRIPTION_ID where to create resources
# PREFIX prepended to all resources name 
./project-cleanup.sh SUBSCRIPTION_ID PREFIX
```

## Usage

```shell
terraform init
terraform apply -var-file azure.tfvars
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.15.4 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 1.6.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.69.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_caravan_bootstrap"></a> [caravan\_bootstrap](#module\_caravan\_bootstrap) | git::https://github.com/bitrockteam/caravan-bootstrap | refs/tags/v0.2.13 |
| <a name="module_cloud_init_control_plane"></a> [cloud\_init\_control\_plane](#module\_cloud\_init\_control\_plane) | git::https://github.com/bitrockteam/caravan-cloudinit | refs/tags/v0.1.13 |
| <a name="module_cloud_init_worker_plane"></a> [cloud\_init\_worker\_plane](#module\_cloud\_init\_worker\_plane) | git::https://github.com/bitrockteam/caravan-cloudinit | refs/tags/v0.1.9 |
| <a name="module_terraform_acme_le"></a> [terraform\_acme\_le](#module\_terraform\_acme\_le) | git::https://github.com/bitrockteam/caravan-acme-le | refs/tags/v0.0.11 |

## Resources

| Name | Type |
|------|------|
| [azuread_application.vault](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_password.vault](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.vault](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_application_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_application_security_group.control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_security_group) | resource |
| [azurerm_application_security_group.monitoring](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_security_group) | resource |
| [azurerm_application_security_group.worker_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_security_group) | resource |
| [azurerm_dns_a_record.control_plane_internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.star](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_ns_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.self](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_linux_virtual_machine.control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine.monitoring](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine_scale_set.worker_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_managed_disk.consul_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_managed_disk.csi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_managed_disk.nomad_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_managed_disk.vault_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.monitoring](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_gateway_backend_address_pool_association.control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association) | resource |
| [azurerm_network_interface_application_gateway_backend_address_pool_association.monitoring](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association) | resource |
| [azurerm_network_interface_application_security_group_association.control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) | resource |
| [azurerm_network_interface_application_security_group_association.monitoring](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) | resource |
| [azurerm_network_interface_application_security_group_association.monitoring_2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) | resource |
| [azurerm_network_security_group.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.allow_in_icmp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_in_internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_in_internal_2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_in_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_in_lb_2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_in_ssh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_nomad_consul_envoy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.lb_default_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.lb_default_rules-2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.monitoring](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_role_assignment.control_plane_acr_read](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.control_plane_key_vault_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.control_plane_vault_auth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.worker_plane_acr_read](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subnet.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.worker_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_machine_data_disk_attachment.consul_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.nomad_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.vault_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [local_file.backend_tf_appsupport](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.backend_tf_platform](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ssh_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.tfvars_appsupport](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.tfvars_platform](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.ca_certs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.ca_certs_bundle](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.vault_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.cert_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azuread_client_config.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.parent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |
| [azurerm_image.caravan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/image) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_role_definition.acr_pull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.key_vault_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The Azure Service Principal Client ID which should be used. | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | The Azure Service Principal Client Secret which should be used. | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | The external domain to use for registering DNS names. | `string` | n/a | yes |
| <a name="input_image_resource_group_name"></a> [image\_resource\_group\_name](#input\_image\_resource\_group\_name) | The Azure Resource Group name where Caravan images are available. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure location where to create resources. | `string` | n/a | yes |
| <a name="input_parent_resource_group_name"></a> [parent\_resource\_group\_name](#input\_parent\_resource\_group\_name) | The Azure Resource Group name where a dns zone exists for external\_domain. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A string prefix prepended to resource names. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure Resource Group name in which the objects will be created. | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The Azure Storage Account which is used for Terraform state storage. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure Subscription ID which should be used. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The Azure Tenant ID which should be used. | `string` | n/a | yes |
| <a name="input_use_le_staging"></a> [use\_le\_staging](#input\_use\_le\_staging) | Whether to use Let's Encrypt staging endpoint. | `bool` | n/a | yes |
| <a name="input_allowed_ssh_cidrs"></a> [allowed\_ssh\_cidrs](#input\_allowed\_ssh\_cidrs) | The list of CIDRs from which ssh is allowed. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_app_gateway_subnet_cidr"></a> [app\_gateway\_subnet\_cidr](#input\_app\_gateway\_subnet\_cidr) | The CIDR of the subnet created for the Application Gateway instance. | `string` | `"10.0.2.0/24"` | no |
| <a name="input_ca_certs"></a> [ca\_certs](#input\_ca\_certs) | A group of certificate objects to download locally. This helps when using Let's Encrypt staging environment. | <pre>map(object({<br>    filename = string<br>    pemurl   = string<br>  }))</pre> | <pre>{<br>  "fakeleintermediatex1": {<br>    "filename": "letsencrypt-stg-root-x1.pem",<br>    "pemurl": "https://letsencrypt.org/certs/staging/letsencrypt-stg-root-x1.pem"<br>  },<br>  "fakelerootx1": {<br>    "filename": "letsencrypt-stg-int-r3.pem",<br>    "pemurl": "https://letsencrypt.org/certs/staging/letsencrypt-stg-int-r3.pem"<br>  }<br>}</pre> | no |
| <a name="input_consul_license_file"></a> [consul\_license\_file](#input\_consul\_license\_file) | Path to Consul Enterprise license | `string` | `null` | no |
| <a name="input_control_plane_disk_data_size"></a> [control\_plane\_disk\_data\_size](#input\_control\_plane\_disk\_data\_size) | The size of control plane instances data disk. | `number` | `20` | no |
| <a name="input_control_plane_disk_data_type"></a> [control\_plane\_disk\_data\_type](#input\_control\_plane\_disk\_data\_type) | The type of control plane instances data disk. | `string` | `"Standard_LRS"` | no |
| <a name="input_control_plane_disk_root_size"></a> [control\_plane\_disk\_root\_size](#input\_control\_plane\_disk\_root\_size) | The size of control plane instances root disk. | `number` | `30` | no |
| <a name="input_control_plane_disk_root_type"></a> [control\_plane\_disk\_root\_type](#input\_control\_plane\_disk\_root\_type) | The type of control plane instances root disk. | `string` | `"Standard_LRS"` | no |
| <a name="input_control_plane_instance_count"></a> [control\_plane\_instance\_count](#input\_control\_plane\_instance\_count) | The number of control plane instances. | `number` | `3` | no |
| <a name="input_control_plane_size"></a> [control\_plane\_size](#input\_control\_plane\_size) | The size of control plane instances. | `string` | `"Standard_B2s"` | no |
| <a name="input_csi_volumes"></a> [csi\_volumes](#input\_csi\_volumes) | Example:<br>{<br>  "jenkins" : {<br>    "storage\_account\_type" : "Standard\_LRS"<br>    "disk\_size\_gb" : "30"<br>  }<br>} | `map(map(string))` | `{}` | no |
| <a name="input_dc_name"></a> [dc\_name](#input\_dc\_name) | The Consul DC name. | `string` | `"azure-dc"` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Whether to create an additional instance for monitoring purposes. | `bool` | `true` | no |
| <a name="input_image_name_regex"></a> [image\_name\_regex](#input\_image\_name\_regex) | The Azure Compute image name regex | `string` | `"caravan-centos-image-*"` | no |
| <a name="input_monitoring_disk_size"></a> [monitoring\_disk\_size](#input\_monitoring\_disk\_size) | The size of monitoring instance disk. | `string` | `"40"` | no |
| <a name="input_monitoring_size"></a> [monitoring\_size](#input\_monitoring\_size) | The size of monitoring instance. | `string` | `"Standard_B2s"` | no |
| <a name="input_nomad_license_file"></a> [nomad\_license\_file](#input\_nomad\_license\_file) | Path to Nomad Enterprise license | `string` | `null` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | The CIDR of the subnet created for Compute instances. | `string` | `"10.0.1.0/24"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A set of key-value tags applied to all resources created by Terraform. | `map(string)` | <pre>{<br>  "project": "caravan"<br>}</pre> | no |
| <a name="input_vault_auth_resource"></a> [vault\_auth\_resource](#input\_vault\_auth\_resource) | The Azure AD application to use for generating access tokens. | `string` | `"https://management.azure.com/"` | no |
| <a name="input_vault_license_file"></a> [vault\_license\_file](#input\_vault\_license\_file) | Path to Vault Enterprise license | `string` | `null` | no |
| <a name="input_vnet_cidrs"></a> [vnet\_cidrs](#input\_vnet\_cidrs) | The CIDR of the created Virtual Network. | `list(string)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| <a name="input_worker_plane_disk_size"></a> [worker\_plane\_disk\_size](#input\_worker\_plane\_disk\_size) | The size of worker plane instances disk. | `string` | `"40"` | no |
| <a name="input_worker_plane_instance_count"></a> [worker\_plane\_instance\_count](#input\_worker\_plane\_instance\_count) | The number of worker plane instances. | `number` | `3` | no |
| <a name="input_worker_plane_size"></a> [worker\_plane\_size](#input\_worker\_plane\_size) | The size of control plane instances. | `string` | `"Standard_B2s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_appsupport_backend"></a> [appsupport\_backend](#output\_appsupport\_backend) | n/a |
| <a name="output_appsupport_tfvars"></a> [appsupport\_tfvars](#output\_appsupport\_tfvars) | n/a |
| <a name="output_control_plane_role_name"></a> [control\_plane\_role\_name](#output\_control\_plane\_role\_name) | n/a |
| <a name="output_control_plane_service_principal_ids"></a> [control\_plane\_service\_principal\_ids](#output\_control\_plane\_service\_principal\_ids) | n/a |
| <a name="output_csi_volumes"></a> [csi\_volumes](#output\_csi\_volumes) | n/a |
| <a name="output_ips"></a> [ips](#output\_ips) | n/a |
| <a name="output_platform_backend"></a> [platform\_backend](#output\_platform\_backend) | n/a |
| <a name="output_platform_tfvars"></a> [platform\_tfvars](#output\_platform\_tfvars) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | n/a |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | n/a |
| <a name="output_vault_client_id"></a> [vault\_client\_id](#output\_vault\_client\_id) | n/a |
| <a name="output_vault_client_secret"></a> [vault\_client\_secret](#output\_vault\_client\_secret) | n/a |
| <a name="output_vault_resource_name"></a> [vault\_resource\_name](#output\_vault\_resource\_name) | n/a |
| <a name="output_worker_plane_role_name"></a> [worker\_plane\_role\_name](#output\_worker\_plane\_role\_name) | n/a |
| <a name="output_worker_plane_service_principal_ids"></a> [worker\_plane\_service\_principal\_ids](#output\_worker\_plane\_service\_principal\_ids) | n/a |
| <a name="output_workload_backend"></a> [workload\_backend](#output\_workload\_backend) | n/a |
| <a name="output_workload_tfvars"></a> [workload\_tfvars](#output\_workload\_tfvars) | n/a |
| <a name="output_zzz_vault_ad_app"></a> [zzz\_vault\_ad\_app](#output\_zzz\_vault\_ad\_app) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

