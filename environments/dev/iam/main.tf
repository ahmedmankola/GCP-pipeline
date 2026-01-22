resource "google_project_iam_custom_role" "basic_operation_role" {
  role_id     = "basicoperationrole"
  title       = "basic operation role"
  description = "Can view the project and start/stop virtual machines"
  
  permissions = [
    # Project viewing permissions
    "resourcemanager.projects.get",
    
    # VM viewing permissions
    "compute.instances.get",
    "compute.instances.list",
    
    # VM power management permissions
    "compute.instances.start",
    "compute.instances.stop",
    "compute.instances.reset",

    #  Network Viewing Permissions
    "compute.networks.get",
    "compute.networks.list",
    "compute.subnetworks.get",
    "compute.subnetworks.list"
  ]
}

# 2. Assign the Role to a User (Optional - replace with your user email)
resource "google_project_iam_member" "assign_role" {
  project = var.project_id
  role    = google_project_iam_custom_role.vm_operator.id
  member  = "user:ahmed.mankola@gmail.com" 
}
