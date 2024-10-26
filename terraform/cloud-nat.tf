resource "google_compute_address" "nat_ip" {
  name         = "nat-ip"
  address_type = "EXTERNAL"
  region       = var.region
}

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "nat-router"
  network = module.vpc.network_name
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-config"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat_ip.self_link]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on = [
    google_compute_address.nat_ip,
    google_compute_router.router,
  ]
}
