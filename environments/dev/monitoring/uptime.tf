resource "google_monitoring_uptime_check_config" "lb_reachability" {
  display_name = "LB-Reachability-Check"
  timeout      = "10s"
  period       = "60s"
  log_check_failures = true
  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      # This pulls the IP address from the data block
      host       = data.google_compute_global_forwarding_rule.loadbalancer-fr.address
    }
  }

  http_check {
    path         = "/"
    port         = "80"
    request_method = "GET"
    
    # Optional: ensure your LB is returning a healthy 200 code
    accepted_response_status_codes {
      status_class = "STATUS_CLASS_2XX"
    }
  }
}
