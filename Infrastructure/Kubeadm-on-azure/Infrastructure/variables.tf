variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "resource_group" {
  type    = string
  default = "devops_rg"
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "prefix" {
  type        = string
  description = "prefix"
  default     = "dev"
}

variable "num_masters" {
  description = "Number of master nodes"
  type        = number
}

variable "num_workers" {
  description = "Number of worker nodes"
  type        = number
}

locals {
  master_names = [for i in range(var.num_masters) : "mosig-master-${i + 1}"]
  worker_names = [for i in range(var.num_workers) : "mosig-worker-${i + 1}"]
  vmnames      = concat(local.master_names, local.worker_names)
}
variable "vmname" {
  description = "Name of the VM"
  type        = list(string)
  default     = ["mosig-master-1", "mosig-worker-1"]
}

variable "vmname-data" {
  default = "mosig-data"
}
variable "publickey-path" {
  default = "./../.ssh/id_rsa.pub"
}

