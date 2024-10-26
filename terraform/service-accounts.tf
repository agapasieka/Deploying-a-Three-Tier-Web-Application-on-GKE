resource "google_service_account" "gke_sa" {
  account_id   = "gke-service-account"
  display_name = "Dedicated service account for GKE nodes"
}

resource "google_service_account" "bastion_sa" {
  account_id   = "bastion-sa"
  display_name = "Bastion Service Account"
}

resource "google_service_account" "sql_access" {
  account_id   = "sql-access"
  display_name = "Service Account to access Cloud SQL"
}