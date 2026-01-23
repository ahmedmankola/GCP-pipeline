# Create the MySQL Private Instance
resource "google_sql_database_instance" "mysql_private" {
  name             = "mysql-private-instance"
  region           = "europe-west1"
  database_version = "MYSQL_8_0"
  

  settings {
    tier = "db-f1-micro" # Choose appropriate size

    ip_configuration {
      ipv4_enabled    = false                                # Requirement 1: No Public IP
      private_network = data.google_compute_network.sql-vpc.id   # Requirement 2: Private VPC only
    }

    backup_configuration {
      enabled            = true # Requirement 3: Automated Backups
      backup_retention_settings {
        retained_backups = 7    
        retention_unit   = "COUNT"
      }
    }
  }
}
