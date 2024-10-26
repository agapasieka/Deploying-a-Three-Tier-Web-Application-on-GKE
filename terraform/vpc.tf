# Enable the Compute Engine API (required for VPC)
resource "google_project_service" "compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"
  lifecycle {
    prevent_destroy = true
  }
}

# vpc module
module "vpc" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.project_id
  network_name = "my-network"
  version      = ">= 9.3.0"

  subnets = [
    {
      subnet_name   = "gce-subnet"
      subnet_ip     = "10.0.0.0/24"
      subnet_region = var.region

    },
    {
      subnet_name   = "gke-subnet"
      subnet_ip     = "10.10.0.0/24"
      subnet_region = var.region

    },
  ]
  secondary_ranges = {
    gke-subnet = [
      {
        range_name    = "pods"
        ip_cidr_range = "10.20.0.0/14"
      },
      {
        range_name    = "services"
        ip_cidr_range = "10.30.0.0/20"
      },
    ]
  }
}