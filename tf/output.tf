output "service_account" {
  value = google_service_account.terraform.email
}

output "ip_address" {
  value = google_compute_instance.terraform.network_interface[0].access_config[0].nat_ip
}

output "key-name" {
  value = google_service_account_key.key.name
}