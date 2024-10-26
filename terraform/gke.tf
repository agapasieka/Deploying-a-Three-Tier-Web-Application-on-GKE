# Enable the Kubernetes Engine API
resource "google_project_service" "container_api" {
  project = var.project_id
  service = "container.googleapis.com"
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_container_cluster" "gke_cluster" {
  name                     = "wordpress-gke-cluster"
  location                 = var.region
  network                  = module.vpc.network_name
  subnetwork               = module.vpc.subnets_names[1]
  initial_node_count       = 1
  remove_default_node_pool = true
  networking_mode          = "VPC_NATIVE"

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.13.0.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = module.vpc.subnets_secondary_ranges[1][0].range_name
    services_ipv4_cidr_block = module.vpc.subnets_secondary_ranges[1][1].range_name
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.7/32"
      display_name = "net1"
    }
  }
}

resource "google_container_node_pool" "primary_node_pool" {
  name       = "primary-node-pool"
  location   = var.region
  cluster    = google_container_cluster.gke_cluster.name
  node_count = 1

  node_config {
    machine_type    = "e2-medium"
    service_account = google_service_account.gke_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}