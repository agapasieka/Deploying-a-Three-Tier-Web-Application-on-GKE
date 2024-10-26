resource "google_compute_firewall" "allow_iap_ssh" {
  project = var.project_id
  name    = "allow-iap-ssh"
  network = module.vpc.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}
