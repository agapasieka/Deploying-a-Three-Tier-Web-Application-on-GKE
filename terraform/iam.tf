resource "google_project_iam_member" "iap_member" {
  project = var.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = google_service_account.bastion_sa.email
}

resource "google_project_iam_member" "sql_access_role" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.sql_access.email}"
}
