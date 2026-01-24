data "google_compute_global_forwarding_rule" "loadbalancer-fr" {
  name    = "nginx-forwarding-rule" 
  project = var.project_id
}
