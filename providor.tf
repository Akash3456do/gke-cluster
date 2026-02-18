terraform {
  required_providers {
    google = {
    }
  }
  backend "gcs" {
    bucket = "backup237"
    prefix = "terraform/gke-harness"
  }
}
provider "google" {
  project = "akash-487011"
}


