terraform {
  required_providers {
    google = {
    }
  }
  backend "gcs" {
    bucket = "backup235"
    prefix = "terraform/gke-harness"
  }
}
provider "google" {
  project = "utopian-nimbus-477714-j0"
}

