provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_version = "1.9.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.8.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.8.0"
    }
  }
}