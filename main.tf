// Create a random postfix for the cluster name
resource "random_id" "postfix" {
  byte_length = 4
}

resource "google_service_account" "anthos-svc" {
  project      = var.project_id
  account_id   = "anthos-${random_id.postfix.hex}-svc"
  display_name = "anthos-${random_id.postfix.hex}-svc"

}
