variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "region" {

}

variable "zones" {
 type = list(string)
}

variable "cluster_name" {

}

variable "nodepool_name" {

}

variable "node_min_count" {

}

variable "node_max_count" {

}

variable "node_initial_count" {

}

variable "node_machine_type" {

}


variable "vpc_network_project_id" {

}

variable "vpc_network" {

}

variable "subnetwork" {

}

variable "ip_range_pods" {

}

variable "ip_range_services" {

}

variable "master_authorized_networks" {

}
