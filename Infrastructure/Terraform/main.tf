# Definition of local variables
locals {
  cluster_name     = google_container_cluster.my_cluster.name
}


resource "google_container_cluster" "my_cluster" {

  name     = var.cluster-name
  location = var.zone
  initial_node_count       = 1
  remove_default_node_pool = true
  ip_allocation_policy {
  }
  deletion_protection = false


}
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster-name}-node-pool"
  location   = var.zone
  cluster    = var.cluster-name
  node_count = var.node_count

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.minNode
    max_node_count = var.maxNode
  }

  timeouts {
    create = "20m"
    update = "20m"
  }


  depends_on = [google_container_cluster.my_cluster]
  node_config {
    preemptible  = true
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    machine_type = "e2-standard-2"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }



  }
}
# Get credentials for cluster
module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform              = "linux"
  additional_components = ["kubectl"]

  create_cmd_entrypoint = "gcloud"
  create_cmd_body = "container clusters get-credentials online-boutique --zone us-central1-a --project spatial-shore-354923"
}

resource "null_resource" "install_argocd" {
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command = <<-EOT
      kubectl create namespace argocd
      kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
      kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
    EOT
  }

  depends_on = [
    module.gcloud,
    google_container_cluster.my_cluster

  ]
}


resource "google_compute_instance" "vm_instance" {
  name         = "test-machine"
  machine_type = "e2-standard-2"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.external_ip.address
    }
  }
  metadata = {
    ssh-keys = "${var.vm_ssh_user}:${file(var.vm_ssh_pub_key_file)}"
  }
  

}
resource "google_compute_address" "external_ip" {
  name = "dynamic-external-ip"
  address_type = "EXTERNAL"
}