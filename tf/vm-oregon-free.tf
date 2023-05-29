# # service account
# resource "google_service_account" "oregon" {
#   account_id = "oregon-account"
#   depends_on = [google_project_service.iam]
# }

# # compute instance
# resource "google_compute_instance" "oregon" {
#   name = "oregon"
#   tags = ["ssh"]

#   machine_type = "e2-micro"
#   zone         = "us-west1-b"

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-minimal-2204-jammy-v20230428"
#       size  = "30"
#       type  = "pd-standard"
#     }
#   }

#   hostname = "oregon.chottodake.dev"

#   service_account {
#     email  = google_service_account.oregon.email
#     scopes = ["compute-rw"]
#   }

#   network_interface {
#     subnetwork = google_compute_subnetwork.oregon.id
#     access_config {
#     }
#   }
# }
