# 1. Reference the existing Subnet
data "google_compute_subnetwork" "private-subnet" {
  name    = "subnet-europe-west1"
  region  = var.region
  project = var.project_id
}
