resource "google_monitoring_alert_policy" "downtime_alert" {
  display_name = "Load Balancer Downtime Alert (>5m)"
  combiner     = "OR"
  
  conditions {
    display_name = "Downtime Duration Condition"
    condition_threshold {
      # Filter links this alert to the specific uptime check created above
      filter     = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\""
      duration   = "300s" 
      
      comparison = "COMPARISON_GT"
      threshold_value = 1 # Trigger if "check_passed" is 0 (failed)
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_FRACTION_TRUE"
      }
    }
  }
  # Add a notification channel (Email/Slack) here if you have one defined
  # notification_channels = [google_monitoring_notification_channel.email.name]
}
