# Instance Template
resource "google_compute_instance_template" "nginx_template" {
  name         = "nginx-template"
  machine_type = "e2-medium"

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2204-lts"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.VM-private_subnet.id
    # No public IP for these backends; they will be behind the LB
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "Hello from $(hostname)" > /var/www/html/index.html
  EOT

  tags = ["allow-health-check"]
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
