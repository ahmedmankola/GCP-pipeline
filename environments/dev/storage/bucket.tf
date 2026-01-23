# 1. Storage Bucket to hold the IP file

resource "google_storage_bucket" "ip_log_bucket" {
  name          = "vm-internal-ip-log"
  location      = var.region
  project       = var.project_id
  force_destroy = true
}


