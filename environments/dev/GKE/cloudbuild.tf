resource "google_cloudbuild_trigger" "gke_deploy_trigger" {
  name     = "deploy-to-gke"
  location = "europe-west1" # Must match your repo/connection location

  # Link to your 2nd Gen Repository resource
  repository_event_config {
    repository = "projects/${var.project_id}/locations/europe-west1/connections/YOUR_CONNECTION_NAME/repositories/GCP-pipeline"
    push {
      branch = "^main$"
    }
  }

  # Path to the build config inside the repo
  filename = "environments/k8s/cloudbuild.yaml"

  substitutions = {
    _CLUSTER_NAME = google_container_cluster.primary.name
    _REGION       = var.region
  }
}
