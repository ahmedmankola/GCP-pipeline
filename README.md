Title: Infrastructure as Code Pipeline (Terraform)
Overview

This repository manages the lifecycle of the GCP environment. To ensure a stable rollout, the infrastructure must be provisioned following a strict dependency graph.
🛠 Pipeline Setup (Manual Actions Required)

    Cloud Build Trigger: Manually create a trigger named infra-deploy pointing to terraform/cloudbuild.yaml.

    Service Account Permissions: Grant the Cloud Build Service Account the following roles at the project level:
     Service Account Permissions (Least Privilege)

To ensure the Cloud Build Service Account ([project-number]@cloudbuild.gserviceaccount.com) can manage the infrastructure without having excessive permissions, assign the following Minimum Roles:
Category	Role Name	Purpose
IAM	roles/resourcemanager.projectIamAdmin	

create Service Accounts and assign IAM bindings.
====================================================
Network	roles/compute.networkAdmin	To create VPCs, Subnets, Firewalls, and Cloud NAT.

Storage	roles/storage.admin	To manage GCS buckets for state files and data.

Database	roles/cloudsql.admin	To provision and manage Cloud SQL instances.

GKE	roles/container.clusterAdmin	To create and manage Kubernetes clusters and node pools.

Compute	roles/compute.instanceAdmin.v1	To manage VM instances and Managed Instance Groups.

Monitoring	roles/monitoring.admin	To create Uptime Checks, Alerting Policies, and Dashboards.

📂 Folder Structure & Deployment Phases
=======================================
To avoid "Resource Not Found" errors, enable and apply the following folders in this specific order:
Phase	Folder	Function

1	iam/	Creates Service Accounts, Custom Roles, and Workload Identity Pools. This is the foundation for security.

2	network/	Provisions the VPC, Subnets, Cloud NAT (for private GKE), and Firewall Rules.

3	storage/	Creates GCS Buckets for state files, static assets, and backups.

4	database/	Configures Cloud SQL (PostgreSQL/MySQL) and Redis instances.

5	gke/	Deploys the Kubernetes Engine cluster, including Node Pools and Autoscalers.

6	compute/	Manages standalone VM instances, Managed Instance Groups (MIGs), and Load Balancers.

7	container/	Sets up Artifact Registry or Container Registry for your Docker images.

8	monitoring/	(Final Phase) Configures Uptime Checks, MQL Alerting Policies, and Dashboards.
