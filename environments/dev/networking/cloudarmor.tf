resource "google_compute_security_policy" "default-policy" {
  name = "allow-all-with-armor"

  # The default rule matches all traffic (0.0.0.0/0)
  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule, allows all traffic"
  }
}
