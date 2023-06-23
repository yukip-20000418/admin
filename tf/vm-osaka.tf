# service account
resource "google_service_account" "terraform" {
  account_id = "terraform-account"
  depends_on = [google_project_service.iam]
}

# data "google_service_account" "terraform_open_test" {
#   project    = "dev-chottodake-open-test"
#   account_id = "terraform"
#   depends_on = [google_project_service.iam]
# }

# compute instance
resource "google_compute_instance" "terraform" {
  name = "terraform"
  tags = ["ssh"]

  machine_type = "e2-medium"
  zone         = "asia-northeast2-a"

  boot_disk {
    initialize_params {
      #   image = "debian-cloud/debian-11"
      #   image = "ubuntu-os-cloud/ubuntu-minimal-2204-jammy-v20230428"
      image = "fedora-coreos-cloud/fedora-coreos-38-20230527-3-0-gcp-x86-64"
      size  = "10"
      type  = "pd-balanced"
    }
  }

  # type-A2
  #   metadata_startup_script = file("./init-vm2.sh")


  hostname = "terraform.chottodake.dev"

  service_account {
    email = google_service_account.terraform.email
    # email  = data.google_service_account.terraform_open_test.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = google_compute_subnetwork.osaka.id
    access_config {
    }
  }
}
