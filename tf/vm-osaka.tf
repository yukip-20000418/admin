# service account
resource "google_service_account" "osaka" {
  account_id = "osaka-account"
  depends_on = [google_project_service.iam]
}

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

  metadata_startup_script = file("./init-vm.sh")
  #    metadata_startup_script = "sudo apt update;sudo apt upgrade -y;sudo apt install git -y"

  #   metadata_startup_script = <<-SCRIPT
  #     #!/bin/bash
  #     #cat <<-'END' >> /etc/needrestart/needrestart.conf
  #     #  #add line
  #     #  $nrconf{restart} = 'a';
  #     #END

  #     #echo "*** start *** $(date)" >> startup-log.txt
  #     #apt update >> startup-log.txt 2>&1
  #     #apt upgrade -y >> startup-log.txt 2>&1
  #     #apt install -y git >> startup-log.txt 2>&1
  #     #echo "*** finish *** $(date)" >> startup-log.txt

  #     cat <<-'END' > /home/yukip/init-memo.sh
  #       #init command memo
  #       sudo apt update
  #       sudo apt install -y git
  #       sudo apt install -y terraform
  #       sudo apt upgrade -y
  #     END

  #     chmod 744 /home/yukip/init-memo.sh
  #     chown yukip:yukip /home/yukip/init-memo.sh
  #   SCRIPT


  # metadata = {
  #   startup-script = <<-SCRIPT
  #     #!/bin/bash
  #     apt update >> startup-log.txt 2>&1
  #     apt upgrade -y >> startup-log.txt 2>&1
  #     apt install -y git >> startup-log.txt 2>&1
  #     date >> test3.txt
  #   SCRIPT
  # }



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
