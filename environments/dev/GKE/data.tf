# 1. Reference the existing Subnet
data "google_compute_subnetwork" "gke-private_subnet" {
  name    = "subnet-europe-west1"
  region  = var.region
  project = var.project_id
}

# 1. Reference the existing Subnet
data "google_compute_network" "gke-vpc" {
  name    = "application-vpc"
  project = var.project_id
}
