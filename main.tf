// Create a random postfix for the cluster name
resource "random_id" "postfix" {
  byte_length = 4
}

resource "google_service_account" "anthos-svc" {
  project      = var.project_id
  account_id   = "anthos-${random_id.postfix.hex}-svc"
  display_name = "anthos-${random_id.postfix.hex}-svc"
}

module "enable_acm" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 2.0"

  platform              = "linux"
  upgrade               = true
  additional_components = ["alpha"]

  service_account_key_file = var.service_account_key_file
  create_cmd_entrypoint    = "gcloud"
  create_cmd_body          = "alpha container hub config-management enable --project ${var.project_id}"
  destroy_cmd_entrypoint   = "gcloud"
  destroy_cmd_body         = "alpha container hub config-management disable --force --project ${var.project_id}"
}
