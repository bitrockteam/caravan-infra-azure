// AUTH
variable "subscription_id" {
  type = string
}
variable "tenant_id" {
  type = string
}
variable "client_id" {
  type = string
}
variable "client_secret" {
  type = string
}

variable "resource_group_name" {
  type = string
}
variable "storage_account_name" {
  type = string
}
variable "prefix" {
  type = string
}
variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {
    project = "caravan"
  }
}

variable "vnet_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}
variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "app_gateway_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}
variable "allowed_ssh_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "control_plane_instance_count" {
  type    = number
  default = 3
}
variable "control_plane_size" {
  type    = string
  default = "Standard_F2"
}
variable "control_plane_disk_size" {
  type    = string
  default = "40"
}
variable "worker_plane_instance_count" {
  type    = number
  default = 3
}
variable "worker_plane_size" {
  type    = string
  default = "Standard_F2"
}
variable "dc_name" {
  type    = string
  default = "azure-dc"
  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*)+$", var.dc_name))
    error_message = "Invalid dc_name. Must contain letters, numbers and hyphen."
  }
}
variable "ca_certs" {
  type = map(object({
    filename = string
    pemurl   = string
  }))
  default = {
    fakeleintermediatex1 = {
      filename = "fakeleintermediatex1.pem"
      pemurl   = "https://letsencrypt.org/certs/fakeleintermediatex1.pem"
    },
    fakelerootx1 = {
      filename = "fakelerootx1.pem"
      pemurl   = "https://letsencrypt.org/certs/fakelerootx1.pem"
    }
  }
}
variable "azure_csi" {
  type    = bool
  default = true
}
variable "external_domain" {
  type    = string
  default = ""
}
variable "parent_resource_group_name" {
  type = string
}
variable "use_le_staging" {
  type = bool
}
