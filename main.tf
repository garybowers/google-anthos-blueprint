// Create a random postfix for the cluster name
resource "random_id" "postfix" {
  byte_length = 4
}

resource "google_service_account" "cluster-svc" {
  project      = var.project_id
  account_id   = "${var.cluster_name}-gke-${random_id.postfix.hex}"
  display_name = "${var.cluster_name}-gke-${random_id.postfix.hex}"

}

resource "google_project_service" "anthos-api" {
  project                    = var.project_id
  service                    = "anthos.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                 = var.project_id
  name                       = "${var.cluster_name}-${random_id.postfix.hex}"
  region                     = var.region
  zones                      = var.zones
  network                    = var.vpc_network
  network_project_id         = var.vpc_network_project_id
  subnetwork                 = var.subnetwork
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = true
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "10.0.0.0/28"

  node_pools = [
    {
      name               = var.nodepool_name 
      machine_type       = var.node_machine_type
      node_locations     = var.zones 
      min_count          = var.node_min_count
      max_count          = var.node_max_count
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = google_service_account.cluster-svc.email
      preemptible        = false
      initial_node_count = var.node_initial_count ? var.node_initial_count : 1
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

