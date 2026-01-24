# 1. The GKE Cluster (Control Plane)
resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "europe-west1"
  # We delete the default pool to use a separately managed one
  remove_default_node_pool = true
  initial_node_count       = 1
  network    = data.google_compute_network.gke-vpc.id
  subnetwork = data.google_compute_subnetwork.gke-private_subnet.id
private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false # Keep the Control Plane public so you can use kubectl
    master_ipv4_cidr_block  = "172.16.0.0/28" # Internal range for the master
  }

  # Required for Private Clusters
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
}

# 2. Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "main-pool"
  location   = "europe-west1"
  cluster    = google_container_cluster.primary.name
  min_node_count = 1
  max_node_count = 1 #
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
