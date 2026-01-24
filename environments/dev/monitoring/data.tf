data "google_compute_global_address" "lb_ip" {
  name    = "nginx-lb" 
  project = var.project_id
}
