variable "resourcegroup" {
  type    = string
  default = "devops_rg"
}
variable "location" {
  type    = string
  default = "francecentral"
}
variable "vmname" {}
variable "subnet_id" {}
variable "prefix" {
  description = "prefix"
  default     = "dev"
}

