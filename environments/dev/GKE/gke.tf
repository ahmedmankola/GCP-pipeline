# 1. The GKE Cluster (Control Plane)
resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "europe-west1"
  # We delete the default pool to use a separately managed one
  remove_default_node_pool = true
  initial_node_count       = 1
  subnetwork = data.google_compute_subnetwork.gke-private_subnet.id
}

# 2. Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "main-pool"
  location   = "europe-west1"
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    preemptible  = true # Saves money for testing
    machine_type = "e2-medium"

    # Assign the custom service account for least privilege
    service_account = google_service_account.build_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
