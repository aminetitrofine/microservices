variable "project_id" {
  type        = string
  description = "The GCP project ID to apply this config to"
}
variable "region" {
  type        = string
  description = "Region of the infrastructure"
  default     = "us-central1"
}
variable "zone" {
  type        = string
  description = "zone of the infrastructure"
  default     = "us-central1-a"
}

variable "credentials_path" {
  default     = "./../../keys/spatial-shore-354923-e11efaceba2c.json"
}

variable "cluster_name" {
    default = "online-boutique"
}

variable "node_count" {
    default = 1
}

variable "minNode" {
    default = 1
}

variable "maxNode" {
    default = 4
}
variable "vm_ssh_user" {
    default = "devops-admin"
}
variable "vm_ssh_pub_key_file" {
    default = "./../../keys/.ssh/id_rsa.pub"
}