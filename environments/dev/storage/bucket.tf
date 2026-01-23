# 1. Storage Bucket to hold the IP file

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "ip_log_bucket" {
  name          = "vm-internal-ip-log-${random_id.bucket_suffix.hex}"
  location      = "EU"
  force_destroy = true
}


