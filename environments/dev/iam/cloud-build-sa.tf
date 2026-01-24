resource "google_service_account" "cloud_build_sa" {
  account_id   = "gke-deployer-sa"
  display_name = "Cloud Build GKE Deployer"
}
