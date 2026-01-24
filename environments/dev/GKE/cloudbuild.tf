resource "google_cloudbuild_trigger" "gke_deploy_trigger" {
  name     = "deploy-to-gke"
  location = "europe-west1" # Must match your repo/connection location
  service_account = data.google_service_account.cloud_build_sa.id
  # Link to your 2nd Gen Repository resource
  repository_event_config {
    repository = "projects/${var.project_id}/locations/europe-west1/connections/pipeline-github-mankola/repositories/ahmedmankola-GCP-pipeline"
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
