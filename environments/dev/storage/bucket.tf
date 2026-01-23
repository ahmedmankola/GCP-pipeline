# 1. Storage Bucket to hold the IP file
resource "google_storage_bucket" "managed_bucket" {
  name          = "vm-internal-ip-log"
  location      = var.region
  project       = var.project_id
  uniform_bucket_level_access = true 
  lifecycle_rule {
    condition {
      age = 7 
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 30 
    }
    action {
      type = "Delete"
    }
  }
}
