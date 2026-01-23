resource "google_cloud_run_v2_service" "cloudrun_service" {
  name     = "cloudrun-service"
  location = "europe-west1"
  deletion_protection = false
  template {
   service_account = google_service_account.cloud_run_sa.email
    containers {
      image = "gcr.io/cloudrun/hello" 
      env {
        name = "DB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.app_secret.secret_id
            version = "latest"
          }
        }
      }
    }
  }
  
  # Ensure secret version exists before service tries to pull it
  depends_on = [google_secret_manager_secret_version.v1]
}
