variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "data"
}

variable "location" {
  description = "Location for the resources"
  type        = string
  default     = "francecentral"
}
variable "prefix" {
  description = "prefix"
  default     = "dev"
}

variable "vmsize" {}
variable "vmname" {}