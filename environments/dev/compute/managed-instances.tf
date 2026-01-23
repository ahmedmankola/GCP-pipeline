# Instance Template
resource "google_compute_instance_template" "nginx_template" {
  name         = "nginx-template"
  machine_type = "e2-small"

  disk {
    source_image = "projects/gdo-skc-hs-cairo/global/images/apache-image"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.VM-private_subnet.id
    # No public IP for these backends; they will be behind the LB
  }

  tags = ["allow-health-check","db-client"]
}

# Regional Managed Instance Group (Across 2 Zones)
resource "google_compute_region_instance_group_manager" "nginx_mig" {
  name               = "nginx-mig"
  region             = var.region
  base_instance_name = "nginx"
  target_size        = 2
  version {
    instance_template = google_compute_instance_template.nginx_template.id
  }
  named_port {
    name = "http"
    port = 80
  }
}
