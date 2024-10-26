resource "google_sql_database_instance" "sql_instance" {
  name             = "wordpress-cloud-sql"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-n1-standard-1"
    ip_configuration {
      private_network = module.vpc.network_name
    }
  }
}

resource "google_sql_database" "wordpress_db" {
  name     = "wordpress"
  instance = google_sql_database_instance.sql_instance.name
}

resource "google_sql_user" "sql_user" {
  name     = "sql"
  instance = google_sql_database_instance.sql_instance.name
  password = data.google_secret_manager_secret.sql_user_secret.secret_id
}

data "google_secret_manager_secret" "sql_user_secret" {
  secret_id = "sql-user-secret"
}