
terraform {
  backend "gcs" {
    bucket = "tf-backend-cicd"
    prefix = "dev/containers"
  }
}
