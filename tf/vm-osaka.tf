# service account
resource "google_service_account" "terraform" {
  account_id = "terraform-account"
  depends_on = [google_project_service.iam]
}

resource "google_project_iam_member" "iam_bind" {
  project = "dev-chottodake-open-test"
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.terraform.name
#   private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

# compute instance
resource "google_compute_instance" "terraform" {
  name = "terraform"
  tags = ["ssh"]

  machine_type = "e2-medium"
  zone         = "asia-northeast2-a"

  boot_disk {
    initialize_params {
      #   image = "debian-cloud/debian-11"
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-jammy-v20230428"
      #   image = "fedora-coreos-cloud/fedora-coreos-38-20230527-3-0-gcp-x86-64"
      size = "10"
      type = "pd-balanced"
    }
  }

  # type-A2
  metadata_startup_script = file("./init-vm2.sh")


  metadata = {
    # iroiro install sareteta
    disable_google_packages = "true"
    enable_oslogin = "false"
    # kore modositemiru
    # install_gcloud = "false"
    key  = base64decode(google_service_account_key.key.private_key)
  }

  hostname = "terraform.chottodake.dev"

  service_account {
    email = google_service_account.terraform.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = google_compute_subnetwork.osaka.id
    access_config {
    }
  }
}
