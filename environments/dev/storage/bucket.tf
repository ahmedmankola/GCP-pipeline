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

# 2. Generate a Signed URL (Requirement 2)
# Note: This requires the provider to have a service account key or impersonation
data "google_storage_object_signed_url" "get_url" {
  bucket       = google_storage_bucket.managed_bucket.name
  path         = "path/to/your/file.txt"
  duration     = "10m" # Valid for 10 minutes
  http_method  = "GET"
}

output "signed_url" {
  value       = data.google_storage_object_signed_url.get_url.signed_url
  description = "The signed URL for the object (valid for 10 mins)"
}
