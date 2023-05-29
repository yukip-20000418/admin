# service account
resource "google_service_account" "osaka" {
  account_id = "osaka-account"
  depends_on = [google_project_service.iam]
}

#############
# gcloud compute instances create-with-container instance-2 \
#     --project=dev-chottodake-admin \
#     --zone=asia-northeast2-a \
#     --machine-type=n1-standard-1 \
#     --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
#     --maintenance-policy=MIGRATE \
#     --provisioning-model=STANDARD \
#     --service-account=954218371077-compute@developer.gserviceaccount.com \
#     --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
#     --image=projects/cos-cloud/global/images/cos-stable-105-17412-101-4 \
#     --boot-disk-size=10GB \
#     --boot-disk-type=pd-standard \
#     --boot-disk-device-name=instance-2 \

#     --container-image=docker.io/hashicorp/terraform \
#     --container-restart-policy=always \
#     --no-shielded-secure-boot \
#     --shielded-vtpm \
#     --shielded-integrity-monitoring \
#     --labels=goog-ec-src=vm_add-gcloud,container-vm=cos-stable-105-17412-101-4
#############

# compute instance
resource "google_compute_instance" "osaka" {
  name = "osaka"
  tags = ["ssh"]

  machine_type = "e2-medium"
  zone         = "asia-northeast2-a"

  boot_disk {
    initialize_params {
      #   image = "debian-cloud/debian-11"
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-jammy-v20230428"
      size  = "10"
      type  = "pd-balanced"
    }
  }

  #   metadata_startup_script = "./init-vm.sh"
   metadata_startup_script = "sudo apt update;sudo apt upgrade -y;sudo apt install git -y"

  hostname = "osaka.chottodake.dev"

  service_account {
    email  = google_service_account.osaka.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = google_compute_subnetwork.osaka.id
    access_config {
    }
  }
}
