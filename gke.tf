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

resource "google_compute_instance" "normal" {
    name         = "normal"
    zone         = "us-central1-a"
    machine_type = "e2-medium"
    boot_disk {
        initialize_params {
            image="projects/ubuntu-os-cloud/global/images/ubuntu-2404-noble-amd64-v20250819"
            size  = 20
            type  = "pd-balanced"
        }
    }
    desired_status = "RUNNING"
    network_interface {
        access_config {}
        subnetwork = google_compute_subnetwork.subnet.id   
    }
    allow_stopping_for_update = true
}