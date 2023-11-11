variable "project_id" {
  type        = string
  description = "The GCP project ID to apply this config to"
}

variable "region" {
  type        = string
  description = "Region of the infrastructure"
  default     = "us-central1"
}

variable "credentials-path" {
  default     = "./../../keys/spatial-shore-354923-e11efaceba2c.json"
}

variable "cluster-name" {
    default = "online-boutique"
}