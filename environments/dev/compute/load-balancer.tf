# 1. Health Check
resource "google_compute_health_check" "http_check" {
  name = "nginx-health-check"
  http_health_check {
    port = 80
  }
}

# 2. Backend Service (MIG)
resource "google_compute_backend_service" "nginx_backend" {
  name                  = "nginx-backend-service"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_health_check.http_check.id]
  
  backend {
    group = google_compute_region_instance_group_manager.nginx_mig.instance_group
  }
}

# 3. Custom Error Page Setup (Backend Bucket)
resource "google_storage_bucket" "error_bucket" {
  name     = "error-page-bucket"
  location = var.region
}

resource "google_compute_backend_bucket" "error_backend" {
  name        = "error-backend"
  bucket_name = google_storage_bucket.error_bucket.name
  enable_cdn  = true
}

# 4. URL Map with Default Service (Error Page)
resource "google_compute_url_map" "nginx_lb" {
  name            = "nginx-lb"
  default_service = google_compute_backend_bucket.error_backend.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "all-paths"
  }

  path_matcher {
    name            = "all-paths"
    default_service = google_compute_backend_service.nginx_backend.id
  }
}

# 5. Frontend (IP + Forwarding Rule)
resource "google_compute_global_forwarding_rule" "http_rule" {
  name       = "nginx-forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = "80"
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "nginx-proxy"
  url_map = google_compute_url_map.nginx_lb.id
}
