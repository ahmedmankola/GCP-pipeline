resource "google_compute_instance" "private_vm" {
  name         = "private-ubuntu-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.VM-private_subnet.id
    # No access_config block = No Public IP
  }

  # Startup Script: Writes internal IP to the bucket
  metadata_startup_script = <<-EOT
    #!/bin/bash
    INTERNAL_IP=$(hostname -I | awk '{print $1}')
    echo "My Internal IP is: $INTERNAL_IP" > ip_info.txt
    gsutil cp ip_info.txt gs://${data.google_storage_bucket.ip_log_bucket.name}/vm_internal_ip.txt
  EOT

  service_account {
    # Ensure the VM has scopes to write to Cloud Storage
    scopes = ["https://www.googleapis.com/auth/devstorage.read_write", "https://www.googleapis.com/auth/logging.write"]
  }
}
