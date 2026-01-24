# 1. Reference the existing Subnet
data "google_compute_subnetwork" "gke-private_subnet" {
  name    = "gke-subnet-europe-west1"
  region  = var.region
  project = var.project_id
}

# 1. Reference the existing Subnet
data "google_compute_network" "gke-vpc" {
  name    = "application-vpc"
  project = var.project_id
}


#data "google_service_account" "cloud_build_sa" {
#    account_id = "gke-build-sa"
#}
