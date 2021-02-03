variable "resource_group_name" {
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