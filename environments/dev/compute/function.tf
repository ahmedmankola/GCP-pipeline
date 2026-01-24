#archive the python script
data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = "code" # Points to your 'code' directory in GitHub
  output_path = "function-source.zip"
}

# 2. Upload the zip to your source bucket
resource "google_storage_bucket_object" "function_zip" {
  name   = "function-source-${data.archive_file.function_source.output_md5}.zip"
  bucket = data.google_storage_bucket.ip_log_bucket.name
  source = data.archive_file.function_source.output_path
}

# 1. Cloud Function 2nd Gen
resource "google_cloudfunctions2_function" "metadata_logger" {
  name        = "storage-metadata-logger"
  location    = "europe-west1"
  description = "Logs filename and size on upload"

  build_config {
    runtime     = "python311"
    entry_point = "log_file_metadata"
    source {
      storage_source {
        bucket = data.google_storage_bucket.ip_log_bucket.name
        object = google_storage_bucket_object.function_zip.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256Mi"
  }

  event_trigger {
    event_type    = "google.cloud.storage.object.v1.finalized"
    trigger_region = "europe-west1" # Must match bucket location
    retry_policy   = "RETRY_POLICY_DO_NOT_RETRY"
    event_filters {
      attribute = "bucket"
      value     = data.google_storage_bucket.ip_log_bucket.name
    }
  }
}


# add pub sub permission for sa 
resource "google_project_iam_member" "gcs_pubsub_publishing" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  # The email format is always service-PROJECT_NUMBER@gs-project-accounts.iam.gserviceaccount.com
  member  = "serviceAccount:service-${var.project_no}@gs-project-accounts.iam.gserviceaccount.com"
}
