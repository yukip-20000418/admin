#test
# data "google_compute_default_service_account" "default" {
#   depends_on = [google_project_service.compute]
# }

# output "default_account_email" {
#   value = data.google_compute_default_service_account.default.email
# }
# output "default_account_unique_id" {
#   value = data.google_compute_default_service_account.default.unique_id
# }
output "new_service_account_admin" {
  value = google_service_account.terraform.email
}
# output "new_service_account_open_test" {
#   value = data.google_service_account.terraform_open_test.email
# }
