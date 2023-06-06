# terraform
terraform {
  backend "gcs" {
    bucket = "admin.chottodake.dev"
    prefix = "tf"
  }
}
# service
resource "google_project_service" "cloudresourcemanager" {
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "compute" {
  service    = "compute.googleapis.com"
  depends_on = [google_project_service.cloudresourcemanager]
}

resource "google_project_service" "iam" {
  service = "iam.googleapis.com"
}

# network
resource "google_compute_network" "admin" {
  name                    = "admin"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.compute]
}
resource "google_compute_subnetwork" "osaka" {
  name          = "osaka"
  ip_cidr_range = "10.2.0.0/16"
  region        = "asia-northeast2"
  network       = google_compute_network.admin.id
}

# firewall
resource "google_compute_firewall" "internal" {
  name    = "internal"
  network = google_compute_network.admin.id
  allow {
    protocol = "all"
  }
  source_ranges = ["10.0.0.0/8", "192.168.0.0/16"]
}

resource "google_compute_firewall" "icmp" {
  name    = "icmp"
  network = google_compute_network.admin.id
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh"
  network = google_compute_network.admin.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = <<EOF
      yukip:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUdeHWpkJIfAkqoimFMPxqOEb8Hbq3Fqui4M9yPKAt1 yukip@MacBookAirM2.local
    EOF
  }
}