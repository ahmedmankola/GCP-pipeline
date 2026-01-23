# 1. Create the Custom VPC
resource "google_compute_network" "application_vpc" {
  name                    = "application-vpc"
  auto_create_subnetworks = false 
  routing_mode            = "GLOBAL" 
}

# 2. Subnet in Region 1 (e.g., US)
resource "google_compute_subnetwork" "subnet_A" {
  name          = "subnet-europe-west1"
  ip_cidr_range = "10.0.0.0/24"
  region        = "europe-west1"
  network       = google_compute_network.application_vpc.id
  
  # Optional: Allows VMs without public IPs to access Google APIs
  private_ip_google_access = true
}

# 3. Subnet in Region 2 (e.g., Europe)
resource "google_compute_subnetwork" "subnet_B" {
  name          = "subnet-europe-west2"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west2"
  network       = google_compute_network.application_vpc.id
  
  private_ip_google_access = true
}

# 1. Allocate a private IP range for Google Managed Services
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "google-managed-services-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = data.google_compute_network.application_vpc.id # Use your VPC data block
}

# 2. Create the Private Service Connection (Peering)
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.application_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

