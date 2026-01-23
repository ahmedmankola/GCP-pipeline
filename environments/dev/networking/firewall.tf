resource "google_compute_firewall" "deny_all_icmp" {
  project = var.project_id
  name    = "fw-rule-i-deny-all-icmp"
  network = google_compute_network.application_vpc.name
  priority = 1000
  direction ="INGRESS" 
   deny {
    protocol = "icmp"
  }
  source_ranges =  [ "0.0.0.0/0" ]
}

resource "google_compute_firewall" "allow_iap" {
  project = var.project_id
  name    = "fw-rule-i-allow-iap"
  network = google_compute_network.application_vpc.name
  priority = 1000
  direction ="INGRESS" 
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges =  [ "35.235.240.0/20" ]
}


# Allow health checks and LB traffic
resource "google_compute_firewall" "allow_lb_hb" {
  name    = "allow-lb-to-backends_hb"
  network = data.google_compute_network.application_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Google LB IP ranges
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
}
