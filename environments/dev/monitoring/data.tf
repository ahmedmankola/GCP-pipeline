data "google_compute_global_forwarding_rule" "loadbalancer-fr" {
  name    = "nginx-lb" 
  project = var.project_id
}
