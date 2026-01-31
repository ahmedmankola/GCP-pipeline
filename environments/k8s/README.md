Title: Kubernetes Application Deployment (K8s)
Overview

This directory contains the logic for the application layer. While Terraform creates the "House" (GKE), this code manages the "Furniture" (your apps).
🚀 Automatic CI/CD Pipeline

The Cloud Build trigger for this directory is automatically provisioned by the terraform/gke or terraform/monitoring code. You do not need to create this in the console.

    Trigger Filter: Watches for changes specifically in the environments/k8s/** path.

    Action: When a PR is merged to main, the pipeline validates the YAML and deploys to GKE.

📂 Component Details
=======================
    deployments/: Defines the desired state for your application (number of replicas, container images, and resource limits).

    services/: Configures Internal and External Load Balancers to expose your app.

    configmaps/ & secrets/: Stores environment-specific variables and sensitive credentials.

    ingress/: Manages SSL/TLS certificates and path-based routing (e.g., api.example.com).

    hpa/: Horizontal Pod Autoscalers to handle traffic spikes automatically.

📦 Container & Application Release Workflow
===========================================
When you update the application source code or the Dockerfile, the automated pipeline performs a full "Build-Push-Deploy" cycle:

    Image Rebuild: Cloud Build detects the change and executes a docker build.

    Versioning: The new image is tagged with a unique identifier (e.g., the Git Commit SHA or an incremental version number like v1.0.2).

    Artifact Registry Push: The pipeline pushes the newly built image to the Artifact Registry (which was created in Phase 4 of the Terraform infrastructure).

    Manifest Update: The pipeline automatically updates the image: field in your Kubernetes deployment.yaml to point to the new version/tag in the registry.

    Rolling Update: kubectl apply is triggered. Kubernetes pulls the new image from Artifact Registry and performs a zero-downtime rolling update.
