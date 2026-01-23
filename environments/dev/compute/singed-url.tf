provider "google" {
  alias        = "impersonated"
  access_token = data.google_service_account_access_token.default.access_token
}

# 2. Get a short-lived token for the service account running the build
data "google_service_account_access_token" "default" {
  target_service_account = "cicd-sa-pipeline@gdo-skc-hs-cairo.iam.gserviceaccount.com"
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "300s"
}
# 2. Generate a Signed URL (Requirement 2)
data "google_storage_object_signed_url" "get_url" {
  provider     = google.impersonated
  bucket       = data.google_storage_bucket.ip_log_bucket.name
  path         = "ip_info.txt"
  duration     = "10m" # Valid for 10 minutes
  http_method  = "GET"
}

output "signed_url" {
  value       = data.google_storage_object_signed_url.get_url.signed_url
  description = "The signed URL for the object (valid for 10 mins)"
}
