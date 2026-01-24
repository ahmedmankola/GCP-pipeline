# Assign the Role to a User (Optional - replace with your user email)
resource "google_project_iam_member" "assign_role" {
  project = var.project_id
  role    = google_project_iam_custom_role.basic_operation_role.id
  member  = "user:ahmed.mankola@gmail.com" 
}


# Grant Logging permissions
resource "google_project_iam_member" "cb_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_build_sa.email}"
}

# Grant Artifact Registry permissions
resource "google_project_iam_member" "cb_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloud_build_sa.email}"
}

# Grant GKE deployment permissions
resource "google_project_iam_member" "cb_gke" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.cloud_build_sa.email}"
}
