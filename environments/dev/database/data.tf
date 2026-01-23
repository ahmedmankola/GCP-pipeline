# 1. Reference the existing Subnet
data "google_compute_network" "sql-vpc" {
  name    = "	application-vpc"
  project = var.project_id
}
