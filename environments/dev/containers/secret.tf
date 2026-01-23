# 1. Create the Secret
resource "google_secret_manager_secret" "app_secret" {
  secret_id = "database-password"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "v1" {
  secret      = google_secret_manager_secret.app_secret.id
  secret_data = "C0MPLEX@TWIX123"
}

# 2. Create a dedicated Service Account for Cloud Run
resource "google_service_account" "cloud_run_sa" {
  account_id   = "cloud-run-accessor"
  display_name = "Cloud Run Secret Accessor"
}

# 3. Grant the SA permission to read the secret
resource "google_secret_manager_secret_iam_member" "secret_access" {
  secret_id = google_secret_manager_secret.app_secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}
