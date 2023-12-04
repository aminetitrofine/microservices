
variable "resourcegroup" {
  type    = string
  default = "devops_rg"
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "admin_username" {
  type    = string
  default = "devops-admin"
}
variable "nic" {}
variable "publickey" {}
variable "vmsize" {}
variable "vmname" {}
variable "public_ip" {}
variable "private_key_path" {}
