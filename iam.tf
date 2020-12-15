resource "google_project_iam_member" "gke-shared-vpc-user-iam" {
  project = var.vpc_network_project_id
  role    = "roles/container.hostServiceAgentUser"
  member  = "serviceAccount:${google_service_account.cluster-svc.email}"
}

