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
| terraform | ~> 0.14.7 |
| azurerm | ~> 2.46 |

## Providers

| Name | Version |
|------|---------|
| azuread | n/a |
| azurerm | ~> 2.46 |
| local | n/a |
| null | n/a |
| random | n/a |
| tls | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| caravan_bootstrap | git::ssh://git@github.com/bitrockteam/caravan-bootstrap?ref=refs/tags/v0.2.1 |  |
| cloud_init_control_plane | git::ssh://git@github.com/bitrockteam/caravan-cloudinit?ref=refs/tags/v0.1.4 |  |
| cloud_init_worker_plane | git::ssh://git@github.com/bitrockteam/caravan-cloudinit?ref=refs/tags/v0.1.4 |  |
| terraform_acme_le | git::ssh://git@github.com/bitrockteam/caravan-acme-le?ref=refs/tags/v0.0.1 |  |

## Resources

| Name |
|------|
| [azuread_application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) |
| [azuread_application_password](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) |
| [azuread_client_config](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) |
| [azuread_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) |
| [azurerm_application_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) |
| [azurerm_application_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_security_group) |
| [azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_dns_a_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) |
| [azurerm_dns_ns_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record) |
| [azurerm_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) |
| [azurerm_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) |
| [azurerm_image](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/image) |
| [azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) |
| [azurerm_key_vault_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) |
| [azurerm_linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) |
| [azurerm_linux_virtual_machine_scale_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) |
| [azurerm_managed_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) |
| [azurerm_network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) |
| [azurerm_network_interface_application_gateway_backend_address_pool_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association) |
| [azurerm_network_interface_application_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) |
| [azurerm_network_security_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) |
| [azurerm_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_role_definition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) |
| [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) |
| [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) |
| [azurerm_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) |
| [azurerm_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) |
| [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) |
| [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_ssh\_cidrs | The list of CIDRs from which ssh is allowed. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| app\_gateway\_subnet\_cidr | The CIDR of the subnet created for the Application Gateway instance. | `string` | `"10.0.2.0/24"` | no |
| ca\_certs | A group of certificate objects to download locally. This helps when using Let's Encrypt staging environment. | <pre>map(object({<br>    filename = string<br>    pemurl   = string<br>  }))</pre> | <pre>{<br>  "fakeleintermediatex1": {<br>    "filename": "letsencrypt-stg-root-x1.pem",<br>    "pemurl": "https://letsencrypt.org/certs/staging/letsencrypt-stg-root-x1.pem"<br>  },<br>  "fakelerootx1": {<br>    "filename": "letsencrypt-stg-int-r3.pem",<br>    "pemurl": "https://letsencrypt.org/certs/staging/letsencrypt-stg-int-r3.pem"<br>  }<br>}</pre> | no |
| client\_id | The Azure Service Principal Client ID which should be used. | `string` | n/a | yes |
| client\_secret | The Azure Service Principal Client Secret which should be used. | `string` | n/a | yes |
| consul\_license\_file | Path to Consul Enterprise license | `string` | `null` | no |
| control\_plane\_disk\_size | The size of control plane instances disk. | `string` | `"40"` | no |
| control\_plane\_instance\_count | The number of control plane instances. | `number` | `3` | no |
| control\_plane\_size | The size of control plane instances. | `string` | `"Standard_B2s"` | no |
| csi\_volumes | Example:<br>{<br>  "jenkins" : {<br>    "storage\_account\_type" : "Standard\_LRS"<br>    "disk\_size\_gb" : "30"<br>  }<br>} | `map(map(string))` | `{}` | no |
| dc\_name | The Consul DC name. | `string` | `"azure-dc"` | no |
| enable\_monitoring | Whether to create an additional instance for monitoring purposes. | `bool` | `true` | no |
| external\_domain | The external domain to use for registering DNS names. | `string` | n/a | yes |
| image\_name\_regex | The Azure Compute image name regex | `string` | `"caravan-centos-image-*"` | no |
| image\_resource\_group\_name | The Azure Resource Group name where Caravan images are available. | `string` | n/a | yes |
| location | The Azure location where to create resources. | `string` | n/a | yes |
| monitoring\_disk\_size | The size of monitoring instance disk. | `string` | `"40"` | no |
| monitoring\_size | The size of monitoring instance. | `string` | `"Standard_B2s"` | no |
| nomad\_license\_file | Path to Nomad Enterprise license | `string` | `null` | no |
| parent\_resource\_group\_name | The Azure Resource Group name where a dns zone exists for external\_domain. | `string` | n/a | yes |
| prefix | A string prefix prepended to resource names. | `string` | n/a | yes |
| resource\_group\_name | The Azure Resource Group name in which the objects will be created. | `string` | n/a | yes |
| storage\_account\_name | The Azure Storage Account which is used for Terraform state storage. | `string` | n/a | yes |
| subnet\_cidr | The CIDR of the subnet created for Compute instances. | `string` | `"10.0.1.0/24"` | no |
| subscription\_id | The Azure Subscription ID which should be used. | `string` | n/a | yes |
| tags | A set of key-value tags applied to all resources created by Terraform. | `map(string)` | <pre>{<br>  "project": "caravan"<br>}</pre> | no |
| tenant\_id | The Azure Tenant ID which should be used. | `string` | n/a | yes |
| use\_le\_staging | Whether to use Let's Encrypt staging endpoint. | `bool` | n/a | yes |
| vault\_auth\_resource | The Azure AD application to use for generating access tokens. | `string` | `"https://management.azure.com/"` | no |
| vault\_license\_file | Path to Vault Enterprise license | `string` | `null` | no |
| vnet\_cidrs | The CIDR of the created Virtual Network. | `list(string)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| worker\_plane\_disk\_size | The size of worker plane instances disk. | `string` | `"40"` | no |
| worker\_plane\_instance\_count | The number of worker plane instances. | `number` | `3` | no |
| worker\_plane\_size | The size of control plane instances. | `string` | `"Standard_B2s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| appsupport\_backend | n/a |
| appsupport\_tfvars | n/a |
| control\_plane\_role\_name | n/a |
| control\_plane\_service\_principal\_ids | n/a |
| csi\_volumes | n/a |
| ips | n/a |
| platform\_backend | n/a |
| platform\_tfvars | n/a |
| resource\_group\_name | n/a |
| subscription\_id | n/a |
| tenant\_id | n/a |
| vault\_client\_id | n/a |
| vault\_client\_secret | n/a |
| vault\_resource\_name | n/a |
| worker\_plane\_role\_name | n/a |
| worker\_plane\_service\_principal\_ids | n/a |
| workload\_backend | n/a |
| workload\_tfvars | n/a |
| zzz\_vault\_ad\_app | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
