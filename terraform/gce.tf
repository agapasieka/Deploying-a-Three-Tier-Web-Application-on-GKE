resource "google_compute_address" "bastion_internal_ip_addr" {
  project      = var.project_id
  address_type = "INTERNAL"
  region       = var.region
  subnetwork   = module.vpc.subnets_names[0]
  name         = "bastion-ip"
  address      = "10.0.0.7"
  description  = "An internal IP address for Bastion host"
}

resource "google_compute_instance" "bastion" {
  project      = var.project_id
  zone         = var.zone
  name         = "bastion"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = module.vpc.network_name
    subnetwork = module.vpc.subnets_names[0]
    network_ip = google_compute_address.bastion_internal_ip_addr.address
  }

}