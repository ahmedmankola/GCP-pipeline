# 1. Reference the existing Subnet
data "google_compute_subnetwork" "VM-private_subnet" {
  name    = "subnet-europe-west1"
  region  = var.region
  project = var.project_id
}

# 2. Reference the existing Storage Bucket
data "google_storage_bucket" "ip_log_bucket" {
  name    = "vm-internal-ip-log"
  project = var.project_id
}


