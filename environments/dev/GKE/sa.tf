# 1. Create the Custom Build Service Account
resource "google_service_account" "build_sa" {
  account_id   = "gke-deployer-sa"
  display_name = "Cloud Build GKE Deployer"
}

# 2. Assign Granular Roles
# Role A: Push images to Artifact Registry
resource "google_project_iam_member" "artifact_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.build_sa.email}"
}

# Role B: Deploy to GKE
resource "google_project_iam_member" "gke_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.build_sa.email}"
}
