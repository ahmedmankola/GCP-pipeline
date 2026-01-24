resource "google_monitoring_alert_policy" "uptime_alert" {
  display_name = "Alert: Load Balancer IP Reachability Failed"
  combiner     = "OR"
  
  conditions {
    display_name = "Uptime Check Health"
    condition_threshold {
      # This filter links the alert to your specific Uptime Check
      filter = <<EOT
        metric.type="monitoring.googleapis.com/uptime_check/check_passed"
        AND metric.label."check_id"="${google_monitoring_uptime_check_config.lb_reachability.uptime_check_id}"
        AND resource.type="uptime_url"
      EOT

      duration   = "60s" # Time to wait before firing the alert
      comparison = "COMPARISON_GT"
      threshold_value = 1 # 1 means the check passed, anything else is a failure
      
      trigger {
        count = 1
      }

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_FRACTION_TRUE"
      }
    }
  }

  # Ensure you have a notification channel (Email/Slack/etc.)
  notification_channels = [google_monitoring_notification_channel.email_me.name]

  # Good practice: prevents deletion issues if the check is updated
  depends_on = [google_monitoring_uptime_check_config.lb_reachability]
}
