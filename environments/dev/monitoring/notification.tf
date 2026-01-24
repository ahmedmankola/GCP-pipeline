resource "google_monitoring_notification_channel" "email_me" {
  display_name = "On-Call Email"
  type         = "email"
  labels = {
    email_address = "ahmed.mankola@orange.com"
  }
}
