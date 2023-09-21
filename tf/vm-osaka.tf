#service account
resource "google_service_account" "terraform" {
  account_id = "terraform-executor"
  depends_on = [google_project_service.iam]
}

resource "google_project_iam_member" "role" {
  project = "dev-chottodake-open-test"
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.terraform.name
}

#compute instance
resource "google_compute_instance" "terraform" {
  name = "terraform"
  tags = ["ssh"]

  machine_type = "e2-medium"
  #   zone         = "asia-northeast2-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-jammy-v20230428"
      size  = "10"
      type  = "pd-balanced"
    }
  }

  metadata_startup_script = file("./init-vm2.sh")

  metadata = {
    enable_oslogin = "false"
    key            = base64decode(google_service_account_key.key.private_key)
  }

  hostname = "terraform.chottodake.dev"

  service_account {
    email  = google_service_account.terraform.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = google_compute_subnetwork.osaka.id
    access_config {
    }
  }
}
