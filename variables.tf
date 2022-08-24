// Base Azure configuration for the provider and common resources, can be generated via project-setup.sh
variable "subscription_id" {
  type        = string
  description = "The Azure Subscription ID which should be used."
}
variable "tenant_id" {
  type        = string
  description = "The Azure Tenant ID which should be used."
}
variable "client_id" {
  type        = string
  description = "The Azure Service Principal Client ID which should be used."
}
variable "client_secret" {
  type        = string
  description = "The Azure Service Principal Client Secret which should be used."
}
variable "resource_group_name" {
  type        = string
  description = "The Azure Resource Group name in which the objects will be created."
}
variable "storage_account_name" {
  type        = string
  description = "The Azure Storage Account which is used for Terraform state storage."
}
variable "prefix" {
  type        = string
  description = "A string prefix prepended to resource names."
}
variable "location" {
  type        = string
  description = "The Azure location where to create resources."
}

// DNS
variable "external_domain" {
  type        = string
  description = "The external domain to use for registering DNS names."
}
variable "parent_resource_group_name" {
  type        = string
  description = "The Azure Resource Group name where a dns zone exists for external_domain."
}
variable "use_le_staging" {
  type        = bool
  description = "Whether to use Let's Encrypt staging endpoint."
}

// Networking
variable "vnet_cidrs" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "The CIDR of the created Virtual Network."
}
variable "subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "The CIDR of the subnet created for Compute instances."
}
variable "app_gateway_subnet_cidr" {
  type        = string
  default     = "10.0.2.0/24"
  description = "The CIDR of the subnet created for the Application Gateway instance."
}
variable "allowed_ssh_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of CIDRs from which ssh is allowed."
}

// Control Plane
variable "control_plane_instance_count" {
  type        = number
  default     = 3
  description = "The number of control plane instances."
}
variable "control_plane_size" {
  type        = string
  default     = "Standard_B2s"
  description = "The size of control plane instances."
}

variable "control_plane_disk_root_size" {
  type        = number
  default     = 30
  description = "The size of control plane instances root disk."
}

variable "control_plane_disk_root_type" {
  type        = string
  default     = "Standard_LRS"
  description = "The type of control plane instances root disk."
}

variable "control_plane_disk_data_size" {
  type        = number
  default     = 20
  description = "The size of control plane instances data disk."
}

variable "control_plane_disk_data_type" {
  type        = string
  default     = "Standard_LRS"
  description = "The type of control plane instances data disk."
}

// Worker plane
variable "worker_plane_instance_count" {
  type        = number
  default     = 3
  description = "The number of worker plane instances."
}
variable "worker_plane_size" {
  type        = string
  default     = "Standard_B2s"
  description = "The size of control plane instances."
}
variable "worker_plane_disk_size" {
  type        = string
  default     = "40"
  description = "The size of worker plane instances disk."
}

// Monitoring
variable "enable_monitoring" {
  type        = bool
  default     = true
  description = "Whether to create an additional instance for monitoring purposes."
}
variable "monitoring_disk_size" {
  type        = string
  default     = "40"
  description = "The size of monitoring instance disk."
}
variable "monitoring_size" {
  type        = string
  default     = "Standard_B4ms"
  description = "The size of monitoring instance."
}

variable "dc_name" {
  type    = string
  default = "azure-dc"
  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*)+$", var.dc_name))
    error_message = "Invalid dc_name. Must contain letters, numbers and hyphen."
  }
  description = "The Consul DC name."
}
variable "ca_certs" {
  type = map(object({
    filename = string
    pemurl   = string
  }))
  default = {
    fakeleintermediatex1 = {
      filename = "letsencrypt-stg-root-x1.pem"
      pemurl   = "https://letsencrypt.org/certs/staging/letsencrypt-stg-root-x1.pem"
    },
    fakelerootx1 = {
      filename = "letsencrypt-stg-int-r3.pem"
      pemurl   = "https://letsencrypt.org/certs/staging/letsencrypt-stg-int-r3.pem"
    }
  }
  description = "A group of certificate objects to download locally. This helps when using Let's Encrypt staging environment."
}
variable "image_resource_group_name" {
  type        = string
  description = "The Azure Resource Group name where Caravan images are available."
}
variable "image_name_regex" {
  type        = string
  default     = "caravan-os-centos-7-*"
  description = "The Azure Compute image name regex"
}
variable "vault_auth_resource" {
  type        = string
  default     = "https://management.azure.com/"
  description = "The Azure AD application to use for generating access tokens."
}
variable "csi_volumes" {
  type        = map(map(string))
  default     = {}
  description = <<EOF
Example:
{
  "jenkins" : {
    "storage_account_type" : "Standard_LRS"
    "disk_size_gb" : "30"
  }
}
EOF
}

variable "tags" {
  type = map(string)
  default = {
    project = "caravan"
  }
  description = "A set of key-value tags applied to all resources created by Terraform."
}

variable "vault_license_file" {
  type        = string
  default     = null
  description = "Path to Vault Enterprise license"
}
variable "consul_license_file" {
  type        = string
  default     = null
  description = "Path to Consul Enterprise license"
}
variable "nomad_license_file" {
  type        = string
  default     = null
  description = "Path to Nomad Enterprise license"
}
