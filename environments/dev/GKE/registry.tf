resource "google_artifact_registry_repository" "my_repo" {
  location      = "europe-west1"
  repository_id = "my-web-app-repo"
  description   = "Docker repository for GKE app"
  format        = "DOCKER"
}
