# service account
resource "google_service_account" "terraform" {
  account_id = "terraform-account"
  depends_on = [google_project_service.iam]
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
      size  = "10"
      type  = "pd-balanced"
    }
  }

  # type-A
  #   metadata_startup_script = file("./init-vm.sh")
  # type-A2
  metadata_startup_script = file("./init-vm2.sh")

  # type-B
  #   metadata_startup_script = <<-SCRIPT
  #     #!/bin/bash
  #     #echo "*** start *** $(date)" >> startup-log.txt
  #     #apt update >> startup-log.txt 2>&1
  #     #apt upgrade -y >> startup-log.txt 2>&1
  #     #apt install -y git >> startup-log.txt 2>&1
  #     #echo "*** finish *** $(date)" >> startup-log.txt
  #   SCRIPT

  # type-C
  #   metadata_startup_script = <<-SCRIPT
  #     cat <<-'END' > /home/yukip/init.sh
  #       #init command memo
  #       sudo apt update
  #       sudo apt upgrade -y
  #       sudo apt install -y git
  #     END
  #     chmod 744 /home/yukip/init.sh
  #     chown yukip:yukip /home/yukip/init.sh
  #   SCRIPT

  # type-D
  # metadata = {
  #   startup-script = <<-SCRIPT
  #     #!/bin/bash
  #     #echo "*** start *** $(date)" >> startup-log.txt
  #     #apt update >> startup-log.txt 2>&1
  #     #apt upgrade -y >> startup-log.txt 2>&1
  #     #apt install -y git >> startup-log.txt 2>&1
  #     #echo "*** finish *** $(date)" >> startup-log.txt
  #   SCRIPT
  # }

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
