Title: Kubernetes Application Deployment (K8s)
Overview

This directory contains the logic for the application layer. While Terraform creates the "House" (GKE), this code manages the "Furniture" (your apps).
🚀 Automatic CI/CD Pipeline

The Cloud Build trigger for this directory is automatically provisioned by the terraform/gke or terraform/monitoring code. You do not need to create this in the console.

    Trigger Filter: Watches for changes specifically in the environments/k8s/** path.

    Action: When a PR is merged to main, the pipeline validates the YAML and deploys to GKE.

📂 Component Details

    deployments/: Defines the desired state for your application (number of replicas, container images, and resource limits).

    services/: Configures Internal and External Load Balancers to expose your app.

    configmaps/ & secrets/: Stores environment-specific variables and sensitive credentials.

    ingress/: Manages SSL/TLS certificates and path-based routing (e.g., api.example.com).

    hpa/: Horizontal Pod Autoscalers to handle traffic spikes automatically.
