
data "google_project" "project" {
  project_id = var.vpc_network_project_id
}


resource "google_project_iam_member" "gke-shared-vpc-user-iam-container" {
  project = var.vpc_network_project_id
  role    = "roles/container.hostServiceAgentUser"
  member  = "serviceAccount:${google_service_account.cluster-svc.email}"
}

resource "google_project_iam_member" "gke-shared-vpc-user-iam-compute" {
  project = var.vpc_network_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${google_service_account.cluster-svc.email}"
}

