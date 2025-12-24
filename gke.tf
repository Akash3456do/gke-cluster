variable "node_status" {
  description = "Set to any to turn ON, set to 0 to turn OFF (shut down)"
  type        = number
  default     = 1
}
resource "google_compute_network" "vpc" {
  name = "gke-zonal-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "gke-zonal-subnet"
  region                   = "us-west1"
  network                  = google_compute_network.vpc.name
  ip_cidr_range            = "10.0.0.0/24"
}

resource "google_container_cluster" "primary" {
  name                     = "zonal-private-gke"
  location                 = "us-west1-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.self_link
  subnetwork               = google_compute_subnetwork.subnet.self_link
  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = "us-west1-a"
  cluster    = google_container_cluster.primary.name
  node_count = var.node_status
  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [ "https://www.googleapis.com/auth/cloud-platform"]
  }
}